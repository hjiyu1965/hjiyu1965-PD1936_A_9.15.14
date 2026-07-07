#!/usr/bin/env python3
"""
从 kernel_syms.elf（已应用重定位）读取 __ksymtab_verity_* 条目，
解码出 verity_map / verity_ctr 等真实函数地址。
"""
import struct
from elftools.elf.elffile import ELFFile

VBASE = 0xffffff8008080000
ELF = '/workspace/kernel_syms.elf'

ksymtab_entries = {
    'verity_ctr':           0xffffff800a136e30,
    'verity_dtr':           0xffffff800a136e40,
    'verity_io_hints':      0xffffff800a136e50,
    'verity_iterate_devices':0xffffff800a136e60,
    'verity_map':           0xffffff800a136e70,
    'verity_prepare_ioctl': 0xffffff800a136e80,
    'verity_status':        0xffffff800a136e90,
}

f = open(ELF, 'rb')
elf = ELFFile(f)
data = f.read()

segments = []
for seg in elf.iter_segments():
    if seg['p_type'] == 'PT_LOAD':
        segments.append((seg['p_vaddr'], seg['p_memsz'], seg['p_offset']))

def vaddr_to_foff(vaddr):
    for vstart, vsize, foff in segments:
        if vstart <= vaddr < vstart + vsize:
            return foff + (vaddr - vstart)
    return None

print("=== 从 kernel_syms.elf 读取 ksymtab (已应用重定位) ===")
print()
print("--- 尝试格式 A: u64 value + u64 name (16字节/条) ---")
for name, vaddr in ksymtab_entries.items():
    foff = vaddr_to_foff(vaddr)
    if foff is None or foff + 16 > len(data):
        print(f"{name}: 无法定位")
        continue
    value, name_ptr = struct.unpack('<QQ', data[foff:foff+16])
    name_foff = vaddr_to_foff(name_ptr) if name_ptr else None
    actual_name = b''
    if name_foff and 0 <= name_foff < len(data):
        end = data.find(b'\x00', name_foff)
        if 0 < end - name_foff < 100:
            actual_name = data[name_foff:end]
    func_foff = vaddr_to_foff(value) if value else None
    first8 = data[func_foff:func_foff+8].hex() if func_foff and 0 <= func_foff < len(data)-8 else 'OOB'
    print(f"{name:25s} value={value:#018x} name={actual_name!r:30s} first8={first8}")

print()
print("--- 尝试格式 B: int32 value_off + int32 name_off (8字节/条, prel32) ---")
for name, vaddr in ksymtab_entries.items():
    foff = vaddr_to_foff(vaddr)
    if foff is None or foff + 8 > len(data):
        print(f"{name}: 无法定位")
        continue
    val_off, name_off = struct.unpack('<ii', data[foff:foff+8])
    func_addr = vaddr + val_off
    name_addr = vaddr + name_off
    func_foff = vaddr_to_foff(func_addr)
    first8 = data[func_foff:func_foff+8].hex() if func_foff and 0 <= func_foff < len(data)-8 else 'OOB'
    name_foff = vaddr_to_foff(name_addr)
    actual_name = b''
    if name_foff and 0 <= name_foff < len(data):
        end = data.find(b'\x00', name_foff)
        if 0 < end - name_foff < 100:
            actual_name = data[name_foff:end]
    print(f"{name:25s} func={func_addr:#018x} name={actual_name!r:30s} first8={first8}")

print()
print("--- 扫描 ksymtab_verity_map 附近 0x40 字节 ---")
vaddr = ksymtab_entries['verity_map']
foff = vaddr_to_foff(vaddr)
for i in range(0, 0x40, 4):
    val = struct.unpack('<I', data[foff+i:foff+i+4])[0]
    print(f"  +{i:#04x}: {val:#010x}")
