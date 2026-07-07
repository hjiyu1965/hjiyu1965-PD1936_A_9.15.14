#!/usr/bin/env python3
"""
解析 arm64 Image 内嵌的 kallsyms 符号表
找到 dm-verity 相关函数地址
"""
import struct

with open('/workspace/boot.img', 'rb') as f:
    boot = f.read()

page_size = struct.unpack_from('<I', boot, 36)[0]
kernel_size = struct.unpack_from('<I', boot, 8)[0]
kernel_off = page_size
kernel = boot[kernel_off:kernel_off + kernel_size]

VBASE = 0xffffff8008080000

# 1. 搜索 kallsyms_token_table
# 它是一个以 \0 分隔的字符串数组, 包含符号名中的 token
# 通常在内核数据段末尾
# 特征: 前面是 kallsyms_markers (int 数组), 后面是 kallsyms_token_index

# 先搜索已知符号名字符串 "dm_verity_ctr" 在 kallsyms_names 区域
# kallsyms_names 是压缩的, 每个符号名用 token 索引表示
# token_table 里有 "dm_" "verity" "_ctr" 等 token

# 搜索 "dm_verity" 在 kernel 中的所有位置
import re

print("=== 搜索 dm_verity 符号名字符串 ===")
for m in re.finditer(b'dm_verity[a-z_]*', kernel):
    off = m.start()
    end = kernel.index(b'\x00', off) if b'\x00' in kernel[off:off+60] else off+30
    s = kernel[off:end].decode('ascii', errors='replace')
    print(f'  off=0x{off:x} vaddr=0x{VBASE+off:x} "{s}"')

# 2. 搜索 kallsyms_addresses 数组
# 特征: 连续的 8 字节值, 都以 0xffffff80 开头, 递增
# 搜索至少 100 个连续递增的 0xffffff80 地址
print("\n=== 搜索 kallsyms_addresses ===")
target_prefix = b'\x00\x00\x00\x08\x80\xff\xff\xff'  # 可能的地址前缀

# 更好的方法: 搜索连续的递增地址
# 先找一个已知地址
known_addr = 0xffffff80084a3f30  # sel_write_enforce
known_bytes = struct.pack('<Q', known_addr)
print(f'搜索已知地址 0x{known_addr:x} 的字节: {known_bytes.hex()}')
positions = []
start = 0
while True:
    pos = kernel.find(known_bytes, start)
    if pos < 0:
        break
    positions.append(pos)
    start = pos + 1
print(f'找到 {len(positions)} 处:')
for p in positions:
    print(f'  off=0x{p:x} vaddr=0x{VBASE+p:x}')
    # 检查前后是否是连续递增的地址
    if p >= 64 and p + 64 < len(kernel):
        # 读前 8 个地址和后 8 个地址
        print('  前 4 个地址:')
        for i in range(4):
            addr = struct.unpack_from('<Q', kernel, p - 32 + i*8)[0]
            print(f'    0x{addr:016x}')
        print('  后 4 个地址:')
        for i in range(4):
            addr = struct.unpack_from('<Q', kernel, p + 8 + i*8)[0]
            print(f'    0x{addr:016x}')

# 3. 尝试找到 kallsyms_token_index
# 它是一个 unsigned int 数组, 指向 token_table 中每个 token 的偏移
# token_index[0] 通常是 0
# token_table[0] 通常是 "\0" (空 token)

# 搜索连续的递增 int 数组 (token_index 特征)
# token_index 有 ~256 个条目, 值递增
print("\n=== 搜索 kallsyms_token_table ===")
# token_table 特征: 连续的以 \0 结尾的短字符串
# 第一个 token 是空字符串 "\0"
# 后面是单字符或双字符 token

# 搜索 "T\0" "t\0" "e\0" 这种连续的单字符 token (token_table 的特征)
# 但这太常见了

# 让我用另一种方法: 搜索 kallsyms_names
# kallsyms_names 是一个字节数组, 每个符号:
#   1 byte: 长度
#   N bytes: 压缩的符号名 (token 索引)
# 第一个符号通常是 "_text" 或类似

# 搜索连续的 "长度+token" 模式太复杂

# 4. 换一种方法: 搜索 "cpu_online_mask" 或其他已知符号
# 这些符号名在 kallsyms_names 中以压缩形式存储
# 但 token_table 里有完整的 token

# 5. 最终方法: 搜索 token_table
# token_table 包含所有符号名中出现的 token
# 通常以: \0 A B C D ... a b c d ... _ . $ 等开头
# 特征: 连续的单字符 \0 分隔字符串

# 搜索一个以 \0 开头, 然后是连续单字符的模式
print("搜索 token_table 特征...")
for i in range(0, len(kernel) - 100, 4):
    # 检查是否是 token_table 的开头
    # \0 A \0 B \0 C \0 D \0 ...
    if kernel[i] == 0 and kernel[i+1:i+2].isalpha() and kernel[i+2] == 0 and \
       kernel[i+3:i+4].isalpha() and kernel[i+4] == 0 and \
       kernel[i+5:i+6].isalpha() and kernel[i+6] == 0:
        # 可能是 token_table
        # 读前 20 个 token
        tokens = []
        j = i
        for _ in range(20):
            end = kernel.index(b'\x00', j) if b'\x00' in kernel[j:j+20] else j+5
            tok = kernel[j:end]
            tokens.append(tok)
            j = end + 1
        # 检查是否都是合理的 token
        if all(len(t) <= 4 for t in tokens):
            print(f'  可能的 token_table @ off=0x{i:x} vaddr=0x{VBASE+i:x}')
            print(f'  前 20 token: {tokens}')
            # 往前找 token_index (int 数组, 在 token_table 之前)
            # token_index 的最后一个值应该指向 token_table 的开头
            # 搜索往前 256*4 = 1024 字节, 找到连续递增的 int 数组
            for ti_off in range(i - 2048, i - 128, 4):
                if ti_off < 0:
                    continue
                vals = [struct.unpack_from('<I', kernel, ti_off + k*4)[0] for k in range(8)]
                if vals[0] == 0 and all(vals[k] <= vals[k+1] for k in range(7)):
                    # 可能是 token_index
                    # 检查最后一个值是否指向 token_table 开头
                    last_idx = (i - ti_off) // 4 - 1
                    if last_idx > 0 and last_idx < 300:
                        last_val = struct.unpack_from('<I', kernel, ti_off + last_idx*4)[0]
                        if last_val < 2000:  # token_table 偏移应该不大
                            print(f'    可能的 token_index @ off=0x{ti_off:x} vaddr=0x{VBASE+ti_off:x}')
                            print(f'    前 8 值: {vals}')
                            break
