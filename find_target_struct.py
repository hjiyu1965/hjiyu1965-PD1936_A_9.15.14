#!/usr/bin/env python3
"""
读取 verity_target 结构体（由 dm_verity_init 的 adrp+add 推断地址）。
地址 = 0xffffff800a9cc000 + 0x890 = 0xffffff800a9cc890
"""
import struct

VBASE = 0xffffff8008080000
KERNEL = '/workspace/kernel.elf'

with open(KERNEL, 'rb') as f:
    data = f.read()

# verity_target 地址
target_vaddr = 0xffffff800a9cc890
target_foff = target_vaddr - VBASE

print(f"=== verity_target @ {target_vaddr:#018x} (file_off={target_foff:#x}) ===")
print()

# struct target_type (Linux 4.14):
#   +0x00  char *name
#   +0x08  struct module *module
#   +0x10  u32 version[3]        (12 bytes)
#   +0x1c  (4 bytes padding)
#   +0x20  ctr_fn ctr
#   +0x28  dtr_fn dtr
#   +0x30  map_fn map
#   +0x38  clone_and_map_request_fn
#   +0x40  map_request_fn
#   +0x48  release_clone_request_fn
#   +0x50  end_request_fn
#   +0x58  presuspend_fn
#   +0x60  postsuspend_fn
#   +0x68  resume_fn
#   +0x70  status_fn status
#   +0x78  message_fn message
#   +0x80  iterate_devices_fn
#   +0x88  io_hints_fn
#   +0x90  busy_fn
#   +0x98  struct list_head list  (16 bytes)
#   +0xa8  unsigned features_mask
#   +0xac  unsigned features

fields = [
    (0x00, 'Q', 'name'),
    (0x08, 'Q', 'module'),
    (0x10, 'I', 'version[0]'),
    (0x14, 'I', 'version[1]'),
    (0x18, 'I', 'version[2]'),
    (0x1c, 'I', 'padding'),
    (0x20, 'Q', 'ctr'),
    (0x28, 'Q', 'dtr'),
    (0x30, 'Q', 'map'),
    (0x38, 'Q', 'clone_and_map_request'),
    (0x40, 'Q', 'map_request'),
    (0x48, 'Q', 'release_clone_request'),
    (0x50, 'Q', 'end_request'),
    (0x58, 'Q', 'presuspend'),
    (0x60, 'Q', 'postsuspend'),
    (0x68, 'Q', 'resume'),
    (0x70, 'Q', 'status'),
    (0x78, 'Q', 'message'),
    (0x80, 'Q', 'iterate_devices'),
    (0x88, 'Q', 'io_hints'),
    (0x90, 'Q', 'busy'),
    (0x98, 'Q', 'list.next'),
    (0xa0, 'Q', 'list.prev'),
    (0xa8, 'I', 'features_mask'),
    (0xac, 'I', 'features'),
]

# 已知函数地址
known = {
    0xffffff8008ddc578: 'verity_ctr',
    0xffffff8008ddc4d8: 'verity_dtr',
    0xffffff8008ddbe48: 'verity_map',
    0xffffff8008ddc0c8: 'verity_status',
    0xffffff8008ddc410: 'verity_prepare_ioctl',
    0xffffff8008ddc450: 'verity_iterate_devices',
    0xffffff8008ddc480: 'verity_io_hints',
}

for off, fmt, fname in fields:
    size = struct.calcsize(fmt)
    val = struct.unpack('<' + fmt, data[target_foff+off:target_foff+off+size])[0]
    note = ''
    if val in known:
        note = f' <- {known[val]}'
    elif 0xffffff8008080000 <= val <= 0xffffff8020000000:
        # 检查是否是已知函数
        for addr, name in known.items():
            if abs(val - addr) < 0x10:
                note = f' ~ {name}?'
                break
        if not note:
            note = ' <- kernel addr'
    elif val < 0x1000 and val != 0:
        note = f' <- small number'
    print(f"  +{off:#04x} {fname:30s}: {val:#018x}{note}")

# 读 name 字符串
name_ptr = struct.unpack('<Q', data[target_foff:target_foff+8])[0]
name_foff = name_ptr - VBASE
if 0 <= name_foff < len(data):
    end = data.find(b'\x00', name_foff)
    print(f"\n  name string: {data[name_foff:end]}")

# DM_TARGET_IMMUTABLE = 0x2
features = struct.unpack('<I', data[target_foff+0xac:target_foff+0xb0])[0]
features_mask = struct.unpack('<I', data[target_foff+0xa8:target_foff+0xac])[0]
print(f"\n  features_mask = {features_mask:#x}")
print(f"  features      = {features:#x}")
print(f"  DM_TARGET_IMMUTABLE (0x2) set? {'YES' if features & 2 else 'NO'}")
print(f"  features @ file_off = {target_foff + 0xac:#x}")
print(f"  features @ vaddr    = {target_vaddr + 0xac:#x}")

# 打印整个结构体的原始字节
print(f"\n=== 原始字节 (0x00 - 0xb0) ===")
for i in range(0, 0xb0, 16):
    line = data[target_foff+i:target_foff+i+16]
    hex_str = ' '.join(f'{b:02x}' for b in line)
    print(f"  +{i:#04x}: {hex_str}")
