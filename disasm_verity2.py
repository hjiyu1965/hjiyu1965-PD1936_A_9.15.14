#!/usr/bin/env python3
"""
反汇编 dm_verity_init 找到 verity_target 结构体地址，
然后读取该结构体找到 features 字段（DM_TARGET_IMMUTABLE）。

同时反汇编 verity_prepare_ioctl 和搜索 set_disk_ro / dm_table_set_restrictions。
"""
import struct
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_ARM

VBASE = 0xffffff8008080000
KERNEL = '/workspace/kernel.elf'

with open(KERNEL, 'rb') as f:
    data = f.read()

md = Cs(CS_ARCH_ARM64, CS_MODE_ARM)
md.detail = True

def disasm(name, vaddr, size=0x200):
    foff = vaddr - VBASE
    code = data[foff:foff+size]
    print(f"\n{'='*70}")
    print(f"=== {name} @ {vaddr:#018x} (file_off={foff:#x}) ===")
    print(f"{'='*70}")
    for i in md.disasm(code, vaddr):
        bytes_hex = i.bytes.hex()
        note = ''
        if i.mnemonic == 'ret':
            note = ' <<< RET'
        elif i.mnemonic in ('adrp', 'adr') and 'x' in i.op_str:
            note = ' <<< address load'
        elif i.mnemonic == 'bl':
            note = ' <<< CALL'
        elif i.mnemonic == 'ldr' and '[' in i.op_str:
            pass
        print(f"  {i.address:#018x}: {bytes_hex:16s}  {i.mnemonic:8s} {i.op_str}{note}")

# 1. 反汇编 dm_verity_init
disasm('dm_verity_init', 0xffffff800a262620, 0x40)

# 2. 反汇编 verity_prepare_ioctl
disasm('verity_prepare_ioctl', 0xffffff8008ddc410, 0x48)

# 3. 反汇编 verity_ctr 开头
disasm('verity_ctr', 0xffffff8008ddc578, 0x100)

# 4. 搜索 verity_target 结构体
# struct target_type {
#     u64 features;        // offset 0x00  (in some versions)
#     char *name;          // offset 0x08
#     ...
# };
# 实际上 target_type 的 name 是第一个字段
# 在内核 4.14:
# struct target_type {
#     char *name;          // 0x00
#     struct module *module; // 0x08
#     char *version;       // 0x10  (actually u32 version[3] = 12 bytes)
#     ...
# };
# 让我们搜索指向 "verity" 字符串的指针

# "verity" 字符串地址 - 从 __kstrtab_verity_map 等推断
# 实际上 __kstrtab_verity_map 指向 "verity_map" 字符串
# 我们需要找到独立的 "verity" 字符串 (null-terminated, 6 bytes + null)
print("\n" + "="*70)
print("=== 搜索 'verity\\0' 字符串和指向它的指针 ===")
print("="*70)
verity_str = b'verity\x00'
pos = 0
verity_str_addrs = []
while True:
    pos = data.find(verity_str, pos)
    if pos < 0:
        break
    vaddr = VBASE + pos
    # 检查前一个字节不是字母（确保是独立字符串）
    if pos > 0 and data[pos-1:pos].isalpha():
        pos += 1
        continue
    verity_str_addrs.append(vaddr)
    print(f"  'verity\\0' @ vaddr={vaddr:#018x} (file_off={pos:#x})")
    pos += 1

# 搜索指向这些字符串的指针（在 data/rodata 段）
print(f"\n找到 {len(verity_str_addrs)} 个 'verity' 字符串")
print("\n搜索指向这些地址的 8 字节指针...")
for target_addr in verity_str_addrs:
    target_bytes = struct.pack('<Q', target_addr)
    pos = 0
    while True:
        pos = data.find(target_bytes, pos)
        if pos < 0:
            break
        ref_vaddr = VBASE + pos
        # 读这个位置附近的数据，看是否像 target_type 结构体
        # name (ptr) 在 offset 0
        print(f"\n  指向 {target_addr:#018x} 的指针 @ {ref_vaddr:#018x} (file_off={pos:#x})")
        print(f"  此处可能就是 verity_target.name 字段")
        # 打印后面的 0x80 字节作为 u64 数组
        print(f"  结构体内容 (假设 name@0x00):")
        for i in range(0, 0x80, 8):
            if pos + i + 8 <= len(data):
                val = struct.unpack('<Q', data[pos+i:pos+i+8])[0]
                # 检查是否是已知地址
                note = ''
                if val == target_addr:
                    note = ' <- name="verity"'
                elif 0xffffff8008080000 <= val <= 0xffffff8020000000:
                    note = f' <- kernel addr'
                elif val < 0x100:
                    note = f' <- small number (flags?)'
                print(f"    +{i:#04x}: {val:#018x}{note}")
        pos += 8
