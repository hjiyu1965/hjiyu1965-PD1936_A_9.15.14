#!/usr/bin/env python3
"""带符号解析的反汇编: 反汇编指定函数, 标注 bl 目标的符号名 & 是否 vivo 私有"""
import sys
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_ARM

VADDR_BASE = 0xffffff8008080000
FILE_OFF_BASE = 0x240
VIVO_PREFIX = ('vivo', 'bbk', 'rsc')

def v2o(v): return FILE_OFF_BASE + (v - VADDR_BASE)

def load_symbols(path):
    syms = {}
    with open(path) as f:
        for line in f:
            parts = line.split()
            if len(parts) >= 3:
                try:
                    addr = int(parts[0], 16)
                except ValueError:
                    continue
                name = parts[2]
                syms[addr] = name
    return syms

def is_vivo(name):
    return name.startswith(VIVO_PREFIX)

def disasm_func(elf, syms, vaddr_start, vaddr_end, label):
    with open(elf, 'rb') as f:
        off = v2o(vaddr_start)
        f.seek(off)
        code = f.read(vaddr_end - vaddr_start)
    md = Cs(CS_ARCH_ARM64, CS_MODE_ARM)
    md.detail = True
    print(f"\n=== {label} @ 0x{vaddr_start:x} (file_off 0x{off:x}) ===")
    vivo_calls = []
    for ins in md.disasm(code, vaddr_start):
        line = f"  0x{ins.address:x}: {ins.bytes.hex():<12} {ins.mnemonic}"
        if ins.op_str:
            line += f" {ins.op_str}"
        # bl 指令解析目标
        if ins.mnemonic in ('bl', 'b') and ins.op_str.startswith('#'):
            try:
                tgt = int(ins.op_str.lstrip('#'), 0)
                name = syms.get(tgt, f'sub_{tgt:x}')
                tag = ' <<<VIVO' if is_vivo(name) else ''
                line += f"  -> {name}{tag}"
                if is_vivo(name):
                    vivo_calls.append((ins.address, name))
            except ValueError:
                pass
        print(line)
    if vivo_calls:
        print(f"\n  [VIVO 调用点 {len(vivo_calls)} 处]:")
        for addr, name in vivo_calls:
            print(f"    0x{addr:x} -> {name}")
    return vivo_calls

if __name__ == '__main__':
    elf = '/workspace/boot_unpacked/kernel.elf'
    syms = load_symbols('/workspace/boot_unpacked/kallsyms.txt.kallsyms')
    print(f"加载符号 {len(syms)} 个")
    # do_execveat_common: 0xffffff80082b5a10 .. 0xffffff80082b6218
    disasm_func(elf, syms, 0xffffff80082b5a10, 0xffffff80082b6218, 'do_execveat_common')
