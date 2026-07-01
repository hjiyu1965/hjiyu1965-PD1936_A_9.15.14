#!/usr/bin/env python3
"""Disassemble ARM64 kernel: stext entry + key startup functions."""
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN

KERNEL = '/workspace/boot_unpacked/kernel'
BASE = 0xffff800010000000   # virtual base of Image (KASLR off reference)

md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)

with open(KERNEL, 'rb') as f:
    data = f.read()

def disasm_at(file_offset, length, label, count=None):
    """Disassemble at given file offset; vaddr = BASE + file_offset."""
    vaddr = BASE + file_offset
    code = data[file_offset:file_offset+length]
    print(f'\n{"="*78}\n{label}\n  file_offset=0x{file_offset:x}, vaddr=0x{vaddr:x}\n{"="*78}')
    n = 0
    for ins in md.disasm(code, vaddr):
        print(f'  0x{ins.address:08x}:  {ins.bytes.hex():<10s}  {ins.mnemonic:<8s} {ins.op_str}')
        n += 1
        if count and n >= count:
            break

# 1. The first instruction is "b stext", where stext is at file_offset 0x2180000
#    (calculated from branch displacement 0x2180000)
disasm_at(0x2180000, 512, '[A] stext (REAL kernel entry, head.S)', count=80)

# 2. Following the early init, look at __primary_switch which usually
#    follows stext. Skip ahead a bit.
disasm_at(0x2180200, 256, '[B] Code after stext (likely __primary_switch)', count=40)

# 3. Find some interesting ASCII markers in the kernel
markers = [
    b'start_kernel',
    b'paging_init',
    b'__primary_switch',
    b'stext',
    b'_text',
    b'Linux version ',
]
print(f'\n{"="*78}\n[C] String marker locations\n{"="*78}')
for m in markers:
    idx = 0
    found = []
    while True:
        i = data.find(m, idx)
        if i < 0: break
        found.append(i)
        idx = i + 1
        if len(found) >= 3: break
    if found:
        for f in found:
            print(f'  {m.decode():<22s} @ 0x{f:08x}')
    else:
        print(f'  {m.decode():<22s} (not found)')

# 4. Look for kallsyms_token_table - sequences of single chars separated by \0
# The token table is recognizable as a series of <=1-byte strings (mostly).
# Search for a long run of "short strings" pattern.
print(f'\n{"="*78}\n[D] Searching for kallsyms markers\n{"="*78}')
for marker in [b'start_kernel\x00', b'cpu_resume\x00', b'panic\x00',
               b'dump_stack\x00', b'sched_init\x00']:
    i = data.find(marker)
    if i > 0:
        print(f'  {marker[:-1].decode():<20s} @ 0x{i:08x}')
