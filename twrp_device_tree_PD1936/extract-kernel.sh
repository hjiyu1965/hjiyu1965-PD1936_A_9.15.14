#!/bin/bash
# extract-kernel.sh
# 从 recovery.img 提取 kernel 到 prebuilt/kernel (供 TWRP 使用)
# 用法: ./extract-kernel.sh [recovery.img路径]
#
# 默认源: /workspace/recovery.img
# 默认目的: prebuilt/kernel (脚本所在目录)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="${1:-/workspace/recovery.img}"
DST_DIR="$SCRIPT_DIR/prebuilt"
DST="$DST_DIR/kernel"

if [ ! -f "$SRC" ]; then
    echo "错误: recovery.img 不存在: $SRC"
    exit 1
fi

mkdir -p "$DST_DIR"

# 使用 python 解析 Android boot image v2 header
python3 - "$SRC" "$DST" <<'PY'
import struct, sys

src, dst = sys.argv[1], sys.argv[2]

with open(src, 'rb') as f:
    data = f.read()

magic = data[0:8]
if magic != b'ANDROID!':
    print(f'错误: 不是 Android boot image (magic={magic})')
    sys.exit(1)

kernel_size  = struct.unpack_from('<I', data, 8)[0]
page_size    = struct.unpack_from('<I', data, 36)[0]

print(f'kernel_size = {kernel_size} (0x{kernel_size:x})')
print(f'page_size   = {page_size}')

kernel_data = data[page_size : page_size + kernel_size]

with open(dst, 'wb') as f:
    f.write(kernel_data)

print(f'已写入: {dst} ({len(kernel_data)} 字节)')
PY

ls -la "$DST"
