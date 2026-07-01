#!/usr/bin/env python3
"""Disassemble ARM64 kernel Image using capstone."""
import sys
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN

KERNEL = '/workspace/boot_unpacked/kernel'

def disasm_range(data, vaddr, offset, length, label):
    """Disassemble a range and print with a header."""
    md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)
    md.detail = False
    code = data[offset:offset+length]
    print(f'\n{"="*78}\n{label}\n  file_offset=0x{offset:x}, vaddr=0x{vaddr:x}, len={length}\n{"="*78}')
    for ins in md.disasm(code, vaddr):
        print(f'  0x{ins.address:08x}:  {ins.bytes.hex():<10s}  {ins.mnemonic:<8s} {ins.op_str}')

def main():
    with open(KERNEL, 'rb') as f:
        data = f.read()

    # ARM64 Image header gives us:
    #   text_offset = 0x80000  (where kernel is virtually placed after load at 0x80000)
    #   image_size  = 0x3570000
    # The first instruction at file offset 0 is a branch to stext.
    # Kernel is loaded at 0xffff800010000000 - text_offset = 0xffff8000080000 in vaddr space
    # (for 4.14 + KASLR disabled). With KASLR, _text is randomized.
    # For disassembly, base = 0xffff800010000000 (typical) - 0x80000 = 0xffff8000080000
    # We just use file_offset as vaddr for readability.
    base_vaddr = 0xffff800010000000

    # 1. Entry point: file offset 0 (Image header + first branch)
    disasm_range(data, base_vaddr, 0, 256,
                 '[1] ENTRY: ARM64 Image header + first branch (head.S)')

    # 2. stext usually follows the header. After 0x800 (typical head.S area)
    # Disassemble more of the startup code.
    disasm_range(data, base_vaddr + 0x800, 0x800, 512,
                 '[2] After Image header: early startup / cpu_setup (head.S)')

    # 3. Try to find string 'start_kernel' reference is hard without symbols.
    # But we can search for known patterns. Let's also look at the very
    # interesting region around the kernel command line setup.
    # The Linux banner string is at __banner / linux_banner.
    banner = b'Linux version '
    idx = data.find(banner)
    if idx > 0:
        end = data.find(b'\x00', idx)
        banner_str = data[idx:end].decode('utf-8','replace')
        print(f'\n[3] Linux banner found at file offset 0x{idx:x}:')
        print(f'    {banner_str}')

    # 4. Search for the kallsyms_token_table (compressed symbol names)
    # Marker: a sequence of single-byte chars followed by 0x00, typically the
    # token table contains 't' 'T' 'r' 'R' ... up to 256 tokens.
    # Hard to find reliably, skip for now.

    # 5. Show typical kernel entry disassembly of first ~30 instructions.
    print('\n[4] First 30 instructions disassembled:')
    md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)
    count = 0
    for ins in md.disasm(data[:256], base_vaddr):
        print(f'  0x{ins.address:08x}:  {ins.bytes.hex():<10s}  {ins.mnemonic:<8s} {ins.op_str}')
        count += 1
        if count >= 30:
            break

if __name__ == '__main__':
    main()
