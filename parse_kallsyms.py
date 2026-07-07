#!/usr/bin/env python3
"""
直接解析 kernel 内嵌 kallsyms 表，查找所有 verity 相关符号。

kallsyms 结构 (Linux 4.14, arm64):
  kallsyms_offsets      : int32[num_syms]  - 相对 base 的偏移
  kallsyms_relative_base: u64              - 基地址（如果有 CONFIG_KALLSYMS_ABSOLUTE_PERCPU）
  kallsyms_num_syms     : u32 (或 long)
  kallsyms_names        : packed [len_byte + compressed_name]
  kallsyms_markers      : u32[...]         - 每 256 个符号一个 marker
  kallsyms_token_table  : char[]           - 压缩 token
  kallsyms_token_index  : u16[256]         - token 索引
"""
import struct

VBASE = 0xffffff8008080000
KERNEL = '/workspace/kernel.elf'

# vmlinux-to-elf 找到的偏移
OFF_OFFSETS    = 0x01b80600
OFF_NUM_SYMS   = 0x01bf9d00
OFF_NAMES      = 0x01bf9e00
OFF_MARKERS    = 0x01d92300
OFF_TOKENS     = 0x01d93300
OFF_TOKEN_IDX  = 0x01d93700

with open(KERNEL, 'rb') as f:
    data = f.read()

# 1. 读 num_syms
num_syms = struct.unpack('<I', data[OFF_NUM_SYMS:OFF_NUM_SYMS+4])[0]
print(f"kallsyms_num_syms = {num_syms}")

# 2. 读 token_index (u16[256])
token_idx = []
for i in range(256):
    off = OFF_TOKEN_IDX + i * 2
    token_idx.append(struct.unpack('<H', data[off:off+2])[0])

# 3. 读 token_table (从每个 token_index 开始的 null 结尾字符串)
tokens = []
for i in range(256):
    off = OFF_TOKENS + token_idx[i]
    end = data.find(b'\x00', off)
    tokens.append(data[off:end].decode('ascii', errors='replace'))

print(f"tokens (前20): {tokens[:20]}")
print(f"tokens 总数: {len(tokens)}")

# 4. 解码 kallsyms_names
# 格式: 每个符号 = [len_byte][len-1 bytes of token indices]
# 注意: len_byte 可能用 1 字节（符号名 <= 255 token）或更大
def decode_symbol_names(data, start, num_syms):
    """解码 packed symbol names"""
    names = []
    off = start
    for i in range(num_syms):
        if off >= len(data):
            names.append('<ERROR>')
            break
        # 第一个字节：如果最高位为1，则用变长编码
        first = data[off]
        if first == 0:
            names.append('')
            off += 1
            continue
        # 在 4.14 中，长度可能是 1 字节
        length = first
        off += 1
        # 解码 token indices
        name = ''
        for j in range(length):
            if off >= len(data):
                break
            tok_idx = data[off]
            off += 1
            if tok_idx < len(tokens):
                name += tokens[tok_idx]
            else:
                name += '?'
        names.append(name)
    return names

print("\n解码符号名...")
names = decode_symbol_names(data, OFF_NAMES, num_syms)
print(f"成功解码 {len(names)} 个符号")

# 5. 读 offsets (int32[num_syms])
# 检查是否有 kallsyms_relative_base
# 在 4.14 with CONFIG_KALLSYMS_ABSOLUTE_PERCPU, offsets 后面是 relative_base (u64)
# 否则 offsets 是直接相对 base 的偏移

# vmlinux-to-elf 说 "kallsyms_offsets at file offset 0x01b80600"
# num_syms * 4 = 124226 * 4 = 496904 = 0x79428
# offsets end = 0x01b80600 + 0x79428 = 0x01bf9a28
# num_syms at 0x01bf9d00, names at 0x01bf9e00
# 在 offsets 和 num_syms 之间有 0x01bf9d00 - 0x01bf9a28 = 0x2D8 = 728 字节
# 这可能是 relative_base (8 bytes) + padding

# 尝试读 relative_base
off_rel_base = OFF_OFFSETS + num_syms * 4
# 看看这附近的内容
print(f"\noffsets end = {off_rel_base:#x}")
print(f"附近内容:")
for i in range(0, 0x40, 8):
    val = struct.unpack('<Q', data[off_rel_base+i:off_rel_base+i+8])[0]
    print(f"  +{i:#04x}: {val:#018x}")

# 检查 relative_base 是否是 0xffffff8008080000
rel_base = struct.unpack('<q', data[off_rel_base:off_rel_base+8])[0]
print(f"\nkallsyms_relative_base = {rel_base:#x}")

# 6. 计算每个符号的地址
# 如果有 relative_base，地址 = relative_base + offset (int32, signed)
# 否则地址 = VBASE + offset
use_rel_base = (rel_base & 0xffff000000000000) == 0xffff000000000000
base_for_addr = rel_base if use_rel_base else VBASE

print(f"使用基址: {base_for_addr:#x} ({'relative_base' if use_rel_base else 'VBASE'})")

# 7. 找所有 verity 相关符号
print("\n=== verity 相关符号 ===")
verity_syms = []
for i, name in enumerate(names):
    if 'verity' in name.lower() or 'dm_verity' in name.lower():
        off = OFF_OFFSETS + i * 4
        offset_val = struct.unpack('<i', data[off:off+4])[0]
        addr = base_for_addr + offset_val
        verity_syms.append((name, addr, i))
        if len(verity_syms) <= 100:
            print(f"  {name:40s} @ {addr:#018x}  (sym #{i})")

print(f"\n总共找到 {len(verity_syms)} 个 verity 相关符号")
