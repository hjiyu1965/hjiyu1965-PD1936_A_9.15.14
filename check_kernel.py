#!/usr/bin/env python3
"""检查 kernel 数据格式, 用不同方式找符号表"""
import struct

with open('/workspace/boot.img', 'rb') as f:
    data = f.read()

page_size = struct.unpack_from('<I', data, 36)[0]
kernel_size = struct.unpack_from('<I', data, 8)[0]
kernel_off = page_size

kernel = data[kernel_off:kernel_off + kernel_size]
print(f'kernel size: {len(kernel)}')
print(f'前 32 字节: {kernel[:32].hex()}')
print(f'前 4 字节 ASCII: {kernel[:4]}')

# arm64 Image header:
# 0x00: code0 (branch instr)  4 bytes
# 0x04: code1                  4 bytes
# 0x08: text_offset            4 bytes
# 0x0c: image_size             4 bytes
# 0x10: flags                  4 bytes
# 0x14: res2/res3/res4
# 0x20: magic "ARM\x64"        4 bytes
# 0x24: res5
if kernel[0x20:0x24] == b'ARM\x64':
    print('\n这是 arm64 Image!')
    text_offset = struct.unpack_from('<I', kernel, 8)[0]
    image_size = struct.unpack_from('<I', kernel, 0xc)[0]
    print(f'text_offset: 0x{text_offset:x}')
    print(f'image_size: 0x{image_size:x} ({image_size})')

# 搜索 kernel 内嵌的 kallsyms 符号表
# kallsyms 在内核末尾, 符号表通常以连续的内存地址开头
# 找 "dm_verity" 字符串
print('\n=== 搜索 verity 字符串 ===')
import re
for m in re.finditer(b'dm_verity', kernel):
    off = m.start()
    # 往后读字符串
    end = kernel.index(b'\x00', off)
    s = kernel[off:end].decode('ascii', errors='replace')
    print(f'  off=0x{off:x} vaddr=0x{0xffffff8008080000 + off:x} "{s}"')

print('\n=== 搜索 verity_map 字符串 ===')
for m in re.finditer(b'verity_', kernel):
    off = m.start()
    end = kernel.index(b'\x00', off) if b'\x00' in kernel[off:off+100] else off+50
    s = kernel[off:end].decode('ascii', errors='replace')
    if len(s) > 3:
        print(f'  off=0x{off:x} vaddr=0x{0xffffff8008080000 + off:x} "{s}"')

# 搜索关键函数名
for name in [b'dm_verity_ctr', b'dm_verity_map', b'verity_map', b'verity_verify_buf',
             b'verity_end_io', b'dm_table_set_restrictions', b'dm_table_get_mode',
             b'dm_set_target_immutable', b'dm_table_set_immutable']:
    pos = kernel.find(name)
    if pos >= 0:
        print(f'\n找到 "{name.decode()}" @ off=0x{pos:x} vaddr=0x{0xffffff8008080000 + pos:x}')
