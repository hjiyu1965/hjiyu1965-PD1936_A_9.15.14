#!/usr/bin/env python3
"""
对原 vivo kernel (Image 格式) 做 SELinux permissive 二进制 patch。
patch 点: sel_write_enforce @ vaddr 0xffffff80084a3f30
  原: cset w8, ne  (0x1a9f07e8 / 字节序 e8 07 9f 1a)  -> 把非零写入转为 enforcing=1
  新: mov w8, wzr  (0x2a1f03e8 / 字节序 e8 03 1f 2a)  -> 永远 enforcing=0 (permissive)
效果: 用户空间 setenforce 1 / init 写 /sys/fs/selinux/enforce 时，写入值被强制当 0 处理，
      SELinux 始终保持 permissive，配合 Magisk 可 root。
保留: vivo 全部驱动 (built-in)，原 dtb 不动 → 能开机。
"""
import struct, shutil, hashlib

SRC_IMAGE = '/workspace/boot_unpacked/kernel'      # 原 vivo kernel (Image, 44269584 bytes)
DST_IMAGE = '/workspace/kernel_patched.img'        # patched kernel
VADDR_BASE = 0xffffff8008080000
PATCH_VADDR = 0xffffff80084a3f30
ORIG_BYTES = bytes.fromhex('e8079f1a')  # cset w8, ne  (little-endian)
NEW_BYTES  = bytes.fromhex('e8031f2a')  # mov w8, wzr  (little-endian)

img_off = PATCH_VADDR - VADDR_BASE

# 1. 复制原 Image
shutil.copyfile(SRC_IMAGE, DST_IMAGE)

# 2. 校验原字节 + patch
with open(DST_IMAGE, 'r+b') as f:
    f.seek(img_off)
    cur = f.read(4)
    assert cur == ORIG_BYTES, f"原字节不匹配 @ off 0x{img_off:x}: 期望 {ORIG_BYTES.hex()} 实际 {cur.hex()}"
    f.seek(img_off)
    f.write(NEW_BYTES)

# 3. 验证 patch 结果
with open(DST_IMAGE, 'rb') as f:
    f.seek(img_off)
    chk = f.read(4)
    assert chk == NEW_BYTES, f"patch 验证失败: {chk.hex()}"

# 4. 文件信息
import os
orig_size = os.path.getsize(SRC_IMAGE)
new_size  = os.path.getsize(DST_IMAGE)
with open(SRC_IMAGE,'rb') as f: orig_md5 = hashlib.md5(f.read()).hexdigest()
with open(DST_IMAGE,'rb') as f: new_md5  = hashlib.md5(f.read()).hexdigest()

print("=== SELinux permissive patch 完成 ===")
print(f"源 Image:  {SRC_IMAGE}  ({orig_size} bytes, md5 {orig_md5})")
print(f"patch Image: {DST_IMAGE}  ({new_size} bytes, md5 {new_md5})")
print(f"patch 位置: vaddr 0x{PATCH_VADDR:x}  Image offset 0x{img_off:x}")
print(f"  原: {ORIG_BYTES.hex()}  cset w8, ne   (setenforce 1 -> enforcing=1)")
print(f"  新: {NEW_BYTES.hex()}  mov w8, wzr   (setenforce * -> enforcing=0, permissive)")
print(f"仅 4 字节改动, 大小不变 ({orig_size == new_size}), 其余驱动/代码全保留 vivo 原版")
