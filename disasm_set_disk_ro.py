#!/usr/bin/env python3
"""
反汇编 set_disk_ro 和 dm_table_set_restrictions
找到让 dm-verity 设备只读的代码路径。
"""
import struct
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_ARM

VBASE = 0xffffff8008080000
KERNEL = '/workspace/kernel.elf'

with open(KERNEL, 'rb') as f:
    data = f.read()

md = Cs(CS_ARCH_ARM64, CS_MODE_ARM)

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
        elif i.mnemonic == 'bl':
            note = ' <<< CALL'
        elif i.mnemonic in ('adrp', 'adr'):
            note = ' <<< addr'
        print(f"  {i.address:#018x}: {bytes_hex:16s}  {i.mnemonic:8s} {i.op_str}{note}")
        if i.mnemonic == 'ret':
            break

# set_disk_ro
disasm('set_disk_ro', 0xffffff8008515ac0, 0x100)

# dm_table_set_restrictions
disasm('dm_table_set_restrictions', 0xffffff8008dc07c8, 0x300)

# bdev_read_only
disasm('bdev_read_only', 0xffffff8008515ba8, 0x60)
