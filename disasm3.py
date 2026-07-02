#!/usr/bin/env python3
"""反汇编 _vrpb_2_v_r_s_h_s, 解析 adrp+add/ldr 引用的字符串/数据地址"""
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_ARM

VADDR_BASE = 0xffffff8008080000
FILE_OFF_BASE = 0x240

def v2o(v): return FILE_OFF_BASE + (v - VADDR_BASE)

def load_symbols(path):
    syms = {}
    with open(path) as f:
        for line in f:
            p = line.split()
            if len(p) >= 3:
                try: syms[int(p[0],16)] = p[2]
                except: pass
    return syms

def read_str_at(elf, vaddr, maxlen=64):
    """读 vaddr 处的 C 字符串"""
    try:
        with open(elf,'rb') as f:
            f.seek(v2o(vaddr))
            b = f.read(maxlen)
        # 截断到第一个 \0
        i = b.find(b'\x00')
        if i >= 0: b = b[:i]
        try: return b.decode('ascii')
        except: return b.hex()
    except: return None

def disasm(elf, syms, v0, v1, label):
    with open(elf,'rb') as f:
        f.seek(v2o(v0)); code = f.read(v1-v0)
    md = Cs(CS_ARCH_ARM64, CS_MODE_ARM); md.detail = True
    print(f"\n=== {label} @ 0x{v0:x}..0x{v1:x} (size {v1-v0}) ===")
    # 跟踪 adrp 结果用于解析 add/ldr 的目标地址
    adrp_vals = {}
    for ins in md.disasm(code, v0):
        line = f"  0x{ins.address:x}: {ins.bytes.hex():<12} {ins.mnemonic} {ins.op_str}"
        # adrp xN, #imm  -> 记录 xN = imm
        if ins.mnemonic == 'adrp':
            try:
                ops = ins.op_str.replace('#','').split(',')
                reg = ops[0].strip()
                imm = int(ops[1].strip(), 0)
                adrp_vals[reg] = imm
                line += f"  ; {reg} = page 0x{imm:x}"
            except: pass
        # add xN, xM, #imm  -> 若 xM 来自 adrp, 解析地址 + 读字符串
        elif ins.mnemonic == 'add' and ',' in ins.op_str and '#' in ins.op_str:
            try:
                ops = ins.op_str.split(',')
                dst = ops[0].strip(); src = ops[1].strip()
                imm = int(ops[2].strip().lstrip('#'), 0)
                if src in adrp_vals:
                    addr = adrp_vals[src] + imm
                    s = read_str_at(elf, addr)
                    sym = syms.get(addr, '')
                    line += f"  ; -> 0x{addr:x}"
                    if sym: line += f" [{sym}]"
                    if s and len(s)>=2 and s.isprintable(): line += f" str=\"{s}\""
            except: pass
        # ldr xN, [xM, #imm] -> 若 xM 来自 adrp
        elif ins.mnemonic in ('ldr','ldrb','ldrh','ldur','ldurb') and '#' in ins.op_str:
            try:
                ops = ins.op_str.split(',')
                src_part = ops[1].strip()  # [xM, #imm]
                inner = src_part.strip('[]')
                parts = [x.strip() for x in inner.split(',')]
                src = parts[0]
                imm = int(parts[1].lstrip('#'),0) if len(parts)>1 else 0
                if src in adrp_vals:
                    addr = adrp_vals[src] + imm
                    sym = syms.get(addr,'')
                    line += f"  ; -> 0x{addr:x}"
                    if sym: line += f" [{sym}]"
            except: pass
        # bl 目标
        elif ins.mnemonic == 'bl' and ins.op_str.startswith('#'):
            try:
                tgt = int(ins.op_str.lstrip('#'),0)
                name = syms.get(tgt, f'sub_{tgt:x}')
                line += f"  -> {name}"
            except: pass
        print(line)

if __name__ == '__main__':
    elf = '/workspace/boot_unpacked/kernel.elf'
    syms = load_symbols('/workspace/boot_unpacked/kallsyms.txt.kallsyms')
    # _vrpb_2_v_r_s_h_s: 0xffffff80084819b0 .. 0xffffff8008481a70
    disasm(elf, syms, 0xffffff8008481a70, 0xffffff8008481ad8, "_A8_v_r_s_h_s (su字符串识别)")
