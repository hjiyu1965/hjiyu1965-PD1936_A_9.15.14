#!/usr/bin/env python3
"""反汇编 kernel.elf 指定虚拟地址范围 (aarch64)"""
import sys, struct
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_ARM

# LOAD 段1: vaddr=0xffffff8008080000 offset=0x240 (代码/rodata)
VADDR_BASE = 0xffffff8008080000
FILE_OFF_BASE = 0x240

def vaddr_to_off(vaddr):
    return FILE_OFF_BASE + (vaddr - VADDR_BASE)

def disasm(elf_path, vaddr_start, vaddr_end, label=""):
    with open(elf_path, 'rb') as f:
        off = vaddr_to_off(vaddr_start)
        f.seek(off)
        size = vaddr_end - vaddr_start
        code = f.read(size)
    md = Cs(CS_ARCH_ARM64, CS_MODE_ARM)
    md.detail = True
    print(f"=== {label} @ 0x{vaddr_start:x} .. 0x{vaddr_end:x} (file_off 0x{off:x}) ===")
    for ins in md.disasm(code, vaddr_start):
        print(f"  0x{ins.address:x}:  {ins.bytes.hex():<12} {ins.mnemonic} {ins.op_str}")

if __name__ == '__main__':
    elf = '/workspace/boot_unpacked/kernel.elf'
    # enforcing_setup: 0xffffff800a23a6c8
    disasm(elf, 0xffffff800a23a6c8, 0xffffff800a23a760, "enforcing_setup")
    print()
    # sel_write_enforce: 0xffffff80084a3e90
    disasm(elf, 0xffffff80084a3e90, 0xffffff80084a4060, "sel_write_enforce")
