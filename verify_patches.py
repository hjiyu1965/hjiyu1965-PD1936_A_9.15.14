#!/usr/bin/env python3
"""
验证 dm-verity 绕过的 patch 点:
1. bdev_read_only @ 0xffffff8008515ba8 - patch 成 mov w0,wzr; ret
2. verity_map 中的 tbnz @ 0xffffff8008ddbf5c - patch 成无条件跳转跳过验证

同时检查 dm_table_set_restrictions 中调用 set_disk_ro 的位置。
"""
import struct
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_ARM

VBASE = 0xffffff8008080000
KERNEL = '/workspace/kernel.elf'

with open(KERNEL, 'rb') as f:
    data = f.read()

md = Cs(CS_ARCH_ARM64, CS_MODE_ARM)

# 1. 验证 bdev_read_only
print("="*70)
print("=== bdev_read_only @ 0xffffff8008515ba8 ===")
print("="*70)
foff = 0xffffff8008515ba8 - VBASE
code = data[foff:foff+16]
print(f"原始字节: {code.hex()}")
for i in md.disasm(code, 0xffffff8008515ba8):
    print(f"  {i.address:#018x}: {i.bytes.hex():16s}  {i.mnemonic:8s} {i.op_str}")

# patch: mov w0, wzr; ret = e0031f2a c0035fd6
patch_bdev = bytes.fromhex('e0031f2ac0035fd6')
print(f"\nPatch bytes: {patch_bdev.hex()}")
print(f"原始前8字节: {code[:8].hex()}")
print(f"匹配: {code[:8] == bytes.fromhex('600000b4084040f9')}")

# 2. 验证 verity_map 中的 tbnz
print("\n" + "="*70)
print("=== verity_map tbnz @ 0xffffff8008ddbf5c ===")
print("="*70)
foff2 = 0xffffff8008ddbf5c - VBASE
code2 = data[foff2:foff2+8]
print(f"原始字节: {code2.hex()}")
for i in md.disasm(code2, 0xffffff8008ddbf5c):
    print(f"  {i.address:#018x}: {i.bytes.hex():16s}  {i.mnemonic:8s} {i.op_str}")

# tbnz w9, #0, #0xffffff8008ddbf44
# 目标: b #0xffffff8008ddbf44 (无条件跳转)
# 偏移 = 0xffffff8008ddbf44 - 0xffffff8008ddbf5c = -0x18 = -24
# b 指令: 0x14000000 | ((offset/4) & 0x03FFFFFF)
# offset/4 = -6 = 0x3FFFFFA (26-bit two's complement)
# encoding = 0x14000000 | 0x03FFFFFA = 0x17FFFFFA
# 小端: fa ff ff 17
patch_verity = bytes.fromhex('faffff17')
print(f"\nPatch bytes: {patch_verity.hex()}")
print(f"原始前4字节: {code2[:4].hex()}")

# 验证: 反汇编 patch 后的指令
for i in md.disasm(patch_verity + b'\x00\x00\x00\x00', 0xffffff8008ddbf5c):
    print(f"  patched: {i.address:#018x}: {i.bytes.hex():16s}  {i.mnemonic:8s} {i.op_str}")
    if i.mnemonic != 'b':
        break

# 3. 检查 dm_table_set_restrictions 中调用 set_disk_ro 的位置
print("\n" + "="*70)
print("=== 搜索 dm_table_set_restrictions 中的 set_disk_ro 调用 ===")
print("="*70)
# set_disk_ro @ 0xffffff8008515ac0
# dm_table_set_restrictions @ 0xffffff8008dc07c8, size ~0x300
# 搜索 BL 指令跳转到 set_disk_ro
restrictions_start = 0xffffff8008dc07c8
restrictions_end = 0xffffff8008dc0b00
set_disk_ro_addr = 0xffffff8008515ac0

for addr in range(restrictions_start, restrictions_end, 4):
    foff3 = addr - VBASE
    insn_bytes = data[foff3:foff3+4]
    if len(insn_bytes) < 4:
        break
    insn = struct.unpack('<I', insn_bytes)[0]
    # BL 指令: 0x94000000 | (offset26 & 0x03FFFFFF)
    if (insn & 0xFC000000) == 0x94000000:
        offset26 = insn & 0x03FFFFFF
        if offset26 & 0x02000000:
            offset26 -= 0x04000000
        target = addr + offset26 * 4
        if target == set_disk_ro_addr:
            print(f"  找到 BL set_disk_ro @ {addr:#018x}")
            # 反汇编上下文
            for j in range(-16, 20, 4):
                ctx_addr = addr + j
                ctx_foff = ctx_addr - VBASE
                ctx_bytes = data[ctx_foff:ctx_foff+4]
                for ci in md.disasm(ctx_bytes, ctx_addr):
                    note = ' <<< BL set_disk_ro' if j == 0 else ''
                    print(f"    {ci.address:#018x}: {ci.bytes.hex():16s}  {ci.mnemonic:8s} {ci.op_str}{note}")

# 4. 也搜索整个 kernel 中所有调用 set_disk_ro 的位置
print("\n" + "="*70)
print("=== 全局搜索所有调用 set_disk_ro 的 BL 指令 ===")
print("="*70)
count = 0
for pos in range(0, len(data) - 4, 4):
    insn = struct.unpack('<I', data[pos:pos+4])[0]
    if (insn & 0xFC000000) == 0x94000000:
        offset26 = insn & 0x03FFFFFF
        if offset26 & 0x02000000:
            offset26 -= 0x04000000
        target = VBASE + pos + offset26 * 4
        if target == set_disk_ro_addr:
            addr = VBASE + pos
            count += 1
            print(f"  BL set_disk_ro @ {addr:#018x} (file_off={pos:#x})")
            if count >= 20:
                print(f"  ... (more)")
                break
print(f"总共找到 {count} 个调用 set_disk_ro 的位置")
