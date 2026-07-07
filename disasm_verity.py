#!/usr/bin/env python3
"""
反汇编 dm-verity 关键函数，确定 patch 点。

目标:
1. verity_map - 找到 WRITE 检查（return -EIO），nop 掉
2. verity_verify_level - 找到返回值，改成 ret 0
3. verity_end_io - 找到验证调用，跳过
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
        # 标记一些关键模式
        note = ''
        if i.mnemonic == 'ret':
            note = ' <<< RET'
        elif i.mnemonic == 'b' and i.op_str.startswith('#') == False:
            note = ' <<< BRANCH'
        elif i.mnemonic in ('mov', 'movz') and 'w0' in i.op_str and ('#0' in i.op_str or 'wzr' in i.op_str):
            note = ' <<< set w0=0'
        elif i.mnemonic == 'movn' and 'w0' in i.op_str:
            note = ' <<< set w0 (movn)'
        elif '-EIO' in str(i.op_str) or '#0xffffffffffffffea' in i.op_str or '#-0x16' in i.op_str:
            note = ' <<< -EIO?'
        bytes_hex = i.bytes.hex()
        print(f"  {i.address:#018x}: {bytes_hex:16s}  {i.mnemonic:8s} {i.op_str}{note}")
        # Stop at first ret after some instructions (end of function)
        if i.mnemonic == 'ret':
            # Check if this is likely end of function (look at next instruction)
            pass

# 反汇编关键函数
funcs = [
    ('verity_map',           0xffffff8008ddbe48, 0x200),
    ('verity_end_io',        0xffffff8008ddc030, 0x100),
    ('verity_verify_level',  0xffffff8008ddb7b8, 0x250),
    ('verity_ctr',           0xffffff8008ddc578, 0x100),
    ('verity_dtr',           0xffffff8008ddc4d8, 0x100),
    ('verity_io_hints',      0xffffff8008ddc480, 0x60),
    ('verity_prepare_ioctl', 0xffffff8008ddc410, 0x50),
]

for name, addr, size in funcs:
    disasm(name, addr, size)
