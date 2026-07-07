#!/usr/bin/env python3
"""
验证最终的 2 个 dm-verity 绕过 patch:

Patch 12: bdev_read_only -> mov w0, wzr; ret (always return 0 = writable)
  - 允许 mount -o remount,rw /vendor
  - 允许块设备写入（块层用 bdev_read_only 检查）

Patch 13: verity_end_io -> mov w0, wzr; ret (skip all verification)
  - 跳过所有 dm-verity 哈希验证
  - 避免 verity_map 中跳过验证导致 verity_io 未初始化的崩溃
  - verity_map 仍正常设置 verity_io 并提交 bio，但 end_io 不做验证
"""
import struct
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_ARM

VBASE = 0xffffff8008080000
KERNEL = '/workspace/kernel.elf'

with open(KERNEL, 'rb') as f:
    data = f.read()

md = Cs(CS_ARCH_ARM64, CS_MODE_ARM)

# Patch 12: bdev_read_only
print("="*70)
print("Patch 12: bdev_read_only -> return 0")
print("="*70)
addr1 = 0xffffff8008515ba8
foff1 = addr1 - VBASE
orig1 = data[foff1:foff1+8]
patch1 = bytes.fromhex('e0031f2ac0035fd6')  # mov w0, wzr; ret
print(f"地址: {addr1:#018x}")
print(f"文件偏移: {foff1:#x}")
print(f"原始字节: {orig1.hex()}")
print(f"原始指令:")
for i in md.disasm(orig1, addr1):
    print(f"  {i.mnemonic:8s} {i.op_str}")
print(f"Patch字节: {patch1.hex()}")
print(f"Patch指令:")
for i in md.disasm(patch1, addr1):
    print(f"  {i.mnemonic:8s} {i.op_str}")
print(f"匹配原始: {orig1 == bytes.fromhex('600000b4084040f9')}")

# Patch 13: verity_end_io
print("\n" + "="*70)
print("Patch 13: verity_end_io -> return 0")
print("="*70)
addr2 = 0xffffff8008ddc030
foff2 = addr2 - VBASE
orig2 = data[foff2:foff2+8]
patch2 = bytes.fromhex('e0031f2ac0035fd6')  # mov w0, wzr; ret
print(f"地址: {addr2:#018x}")
print(f"文件偏移: {foff2:#x}")
print(f"原始字节: {orig2.hex()}")
print(f"原始指令:")
for i in md.disasm(data[foff2:foff2+16], addr2):
    print(f"  {i.mnemonic:8s} {i.op_str}")
print(f"Patch字节: {patch2.hex()}")
print(f"Patch指令:")
for i in md.disasm(patch2, addr2):
    print(f"  {i.mnemonic:8s} {i.op_str}")
print(f"匹配原始: {orig2 == bytes.fromhex('fd7bbea9f44f01a9')}")

# 验证 boot.img 中的偏移
print("\n" + "="*70)
print("验证 boot.img 中的 patch 偏移")
print("="*70)
# boot.img: page_size=4096, kernel_off=0x1000, kernel_size=44269584
# kernel 在 boot.img 中从 0x1000 开始
# kernel 内偏移 = vaddr - VBASE
# boot.img 内偏移 = kernel_off + (vaddr - VBASE)
BOOT_KERNEL_OFF = 0x1000

for name, vaddr in [("bdev_read_only", addr1), ("verity_end_io", addr2)]:
    kernel_off = vaddr - VBASE
    boot_off = BOOT_KERNEL_OFF + kernel_off
    print(f"  {name}: vaddr={vaddr:#018x} kernel_off={kernel_off:#x} boot_off={boot_off:#x}")
