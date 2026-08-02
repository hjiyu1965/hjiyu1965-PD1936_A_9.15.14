#!/usr/bin/env python3
"""
repack_recovery.py - 用原始 recovery.img 作模板,只替换 ramdisk,保留
header_version=2 + kernel + vivo 签名数据,生成 bootloader 兼容的镜像。

用法:
  python3 repack_recovery.py <orig_recovery.img> <new_ramdisk.img> <out_recovery.img>

原理:
  原始 vivo recovery.img 结构 (page_size=4096, header_version=2):
    [header: 1 page][kernel: N pages][ramdisk: M pages][vivo signature data]
  mkbootimg 打包时:
    1. 强制 header_version 2 必须提供 --dtb,否则报 "DTB image must not be empty"
    2. 不会保留 ramdisk 之后的 vivo 签名数据
  -> 直接用 mkbootimg 打包会丢失签名 + 改 header_version,导致 bootloader 无限重启

  本脚本绕开 mkbootimg,在二进制层面替换 ramdisk:
    - header: 复用原始 header(含原始 cmdline/keyhash 等),只更新 ramdisk_size
    - kernel: 复用原始 kernel(prebuilt/kernel 与原始一致)
    - ramdisk: 替换为 TWRP 编译出的 ramdisk-recovery.img
    - 签名数据: 原样保留 (ramdisk 之后的全部内容)
    - 总大小: 与原始 partition size 一致,不足补 0x00
"""
import struct
import sys
import os

PAGE = 4096

def pages(size):
    return (size + PAGE - 1) // PAGE

def round_up(size):
    return pages(size) * PAGE

def repack(orig_path, new_ramdisk_path, out_path):
    with open(orig_path, 'rb') as f:
        orig = f.read()
    with open(new_ramdisk_path, 'rb') as f:
        new_ramdisk = f.read()

    header = bytearray(orig[:PAGE])
    magic = bytes(header[0:8])
    if magic != b'ANDROID!':
        raise SystemExit(f"ERROR: orig recovery.img magic not ANDROID!: {magic}")

    ksz = struct.unpack('<I', header[8:12])[0]
    orig_rsz = struct.unpack('<I', header[16:20])[0]
    hdr_ver = struct.unpack('<I', header[40:44])[0]
    print(f"[*] orig header_version   : {hdr_ver}")
    print(f"[*] orig kernel_size      : {ksz} ({hex(ksz)})")
    print(f"[*] orig ramdisk_size     : {orig_rsz} ({hex(orig_rsz)})")
    print(f"[*] new  ramdisk_size     : {len(new_ramdisk)} ({hex(len(new_ramdisk))})")

    # 原始 kernel 数据 (page 1 起)
    kernel = orig[PAGE : PAGE + ksz]
    # kernel 页填充
    kpad_len = round_up(ksz) - ksz

    # 原始 ramdisk 之后的全部数据 (含 vivo 签名 d7b7ab1e...)
    kernel_pages = pages(ksz)
    ramdisk_pages = pages(orig_rsz)
    sig_start = (1 + kernel_pages + ramdisk_pages) * PAGE
    sig_data = orig[sig_start:]
    print(f"[*] orig signature offset : {hex(sig_start)}")
    print(f"[*] orig signature size   : {len(sig_data)} ({hex(len(sig_data))})")
    if len(sig_data) >= 16:
        print(f"[*] signature magic       : {sig_data[:4].hex()}")

    # 更新 header 中的 ramdisk_size
    struct.pack_into('<I', header, 16, len(new_ramdisk))

    # 构造新镜像
    out = bytearray()
    out += header                       # 1 page (header, v2)
    out += kernel                       # kernel 数据
    out += b'\x00' * kpad_len           # kernel 页对齐填充
    out += new_ramdisk                  # 新 ramdisk
    rpad_len = round_up(len(new_ramdisk)) - len(new_ramdisk)
    out += b'\x00' * rpad_len           # ramdisk 页对齐填充
    out += sig_data                     # vivo 签名数据 (原样保留)

    # 总大小对齐到原始 partition size
    target_size = len(orig)
    if len(out) > target_size:
        # 新 ramdisk 太大,溢出了签名区域
        # 仍按 target_size 截断(签名数据会被部分覆盖,设备若已解锁仍可启动)
        print(f"[!] WARNING: new image {len(out)} > target {target_size}, "
              f"truncating (signature data partially overwritten)")
        out = out[:target_size]
    elif len(out) < target_size:
        out += b'\x00' * (target_size - len(out))

    with open(out_path, 'wb') as f:
        f.write(out)
    print(f"[+] wrote {out_path}: {len(out)} bytes ({hex(len(out))})")

    # 校验: 回读 header 字段
    with open(out_path, 'rb') as f:
        chk = f.read(PAGE)
    chk_ksz = struct.unpack('<I', chk[8:12])[0]
    chk_rsz = struct.unpack('<I', chk[16:20])[0]
    chk_ver = struct.unpack('<I', chk[40:44])[0]
    print(f"[+] verify: header_version={chk_ver} kernel_size={chk_ksz} ramdisk_size={chk_rsz}")
    assert chk_ksz == ksz, "kernel_size mismatch"
    assert chk_rsz == len(new_ramdisk), "ramdisk_size mismatch"
    assert chk_ver == hdr_ver, "header_version mismatch"
    print("[+] header fields OK")

if __name__ == '__main__':
    if len(sys.argv) != 4:
        print(__doc__)
        sys.exit(1)
    repack(sys.argv[1], sys.argv[2], sys.argv[3])
