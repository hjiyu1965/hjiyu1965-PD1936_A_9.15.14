#!/usr/bin/env python3
"""解包 boot.img 提取 kernel, 找 dm-verity 相关符号"""
import struct, sys
from elftools.elf.elffile import ELFFile
from io import BytesIO

# 1. 解包 boot.img
with open('/workspace/boot.img', 'rb') as f:
    data = f.read()

magic = data[0:8]
print(f'magic: {magic}')
page_size = struct.unpack_from('<I', data, 36)[0]
kernel_size = struct.unpack_from('<I', data, 8)[0]
kernel_off = page_size
print(f'page_size={page_size} kernel_size={kernel_size} kernel_off={hex(kernel_off)}')

# 提取 kernel
kernel_data = data[kernel_off:kernel_off + kernel_size]
with open('/workspace/kernel.elf', 'wb') as f:
    f.write(kernel_data)
print(f'kernel.elf 已提取: {len(kernel_data)} 字节')

# 2. 解析 ELF 符号表, 找 verity 相关符号
elf = ELFFile(BytesIO(kernel_data))

# 找符号表
symtab = None
for section in elf.iter_sections():
    if section.name in ('.symtab', '.kallsyms'):
        symtab = section
        break

if symtab is None:
    print('未找到符号表!')
    sys.exit(1)

print(f'\n符号表: {symtab.name}, {symtab.num_symbols()} 个符号')

# 3. 搜索 verity/dm_verity 相关符号
print('\n=== dm-verity 相关符号 ===')
verity_syms = []
for sym in symtab.iter_symbols():
    name = sym.name
    if not name:
        continue
    name_lower = name.lower()
    if any(kw in name_lower for kw in ['verity', 'dm_verity', 'verify_buf', 'dm_table_set', 'dm_table_get_mode',
                                         'dm_set_target', 'dm_target_iter', 'dm_bufio',
                                         'hashtree', 'hash_tree']):
        if sym['st_value'] != 0 and sym['st_size'] != 0:
            verity_syms.append((sym['st_value'], sym['st_size'], name))
            if len(verity_syms) <= 80:
                print(f'  0x{sym["st_value"]:016x}  size={sym["st_size"]:<6d}  {name}')

print(f'\n共 {len(verity_syms)} 个 verity 相关符号')

# 4. 重点找这几个关键函数
key_funcs = ['dm_verity_ctr', 'dm_verity_map', 'verity_map', 'verity_verify_buf',
             'verity_end_io', 'verity_verify_level', 'verity_hash',
             'dm_table_set_restrictions', 'dm_table_get_mode',
             'dm_verity_alloc', 'dm_verity_dtr']

print('\n=== 关键函数 ===')
for vaddr, size, name in verity_syms:
    for kf in key_funcs:
        if kf in name:
            print(f'  0x{vaddr:016x}  size={size:<6d}  {name}')
            break

# 保存所有符号到文件
with open('/workspace/kallsyms.txt', 'w') as f:
    for sym in symtab.iter_symbols():
        if sym['st_value'] != 0:
            f.write(f'{sym["st_value"]:016x} {sym["st_size"]:6d} {sym.name}\n')
print(f'\n符号表已保存到 /workspace/kallsyms.txt')
