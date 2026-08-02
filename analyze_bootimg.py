#!/usr/bin/env python3
"""分析 Android boot image header (v0/v1/v2/v3/v4)"""
import struct
import sys

def analyze(path):
    with open(path, 'rb') as f:
        data = f.read(4096 * 4)  # 读 16KB 足够覆盖所有 header 版本

    magic = data[0:8]
    print(f"=== {path} ===")
    print(f"magic           : {magic}")
    if magic != b'ANDROID!':
        print("Not an Android boot image")
        return

    # common v0/v1 fields
    kernel_size    = struct.unpack('<I', data[8:12])[0]
    kernel_addr    = struct.unpack('<I', data[12:16])[0]
    ramdisk_size   = struct.unpack('<I', data[16:20])[0]
    ramdisk_addr   = struct.unpack('<I', data[20:24])[0]
    second_size    = struct.unpack('<I', data[24:28])[0]
    second_addr    = struct.unpack('<I', data[28:32])[0]
    tags_addr      = struct.unpack('<I', data[32:36])[0]
    page_size      = struct.unpack('<I', data[36:40])[0]
    header_version = struct.unpack('<I', data[40:44])[0]
    os_version     = struct.unpack('<I', data[44:48])[0]
    name           = data[48:64].rstrip(b'\x00')
    cmdline        = data[64:64+512].split(b'\x00')[0]
    print(f"kernel_size     : {kernel_size} ({hex(kernel_size)})")
    print(f"kernel_addr     : {hex(kernel_addr)}")
    print(f"ramdisk_size    : {ramdisk_size} ({hex(ramdisk_size)})")
    print(f"ramdisk_addr    : {hex(ramdisk_addr)}")
    print(f"second_size     : {second_size}")
    print(f"second_addr     : {hex(second_addr)}")
    print(f"tags_addr       : {hex(tags_addr)}")
    print(f"page_size       : {page_size}")
    print(f"header_version  : {header_version}")
    print(f"os_version      : {hex(os_version)}")
    print(f"name            : {name}")
    print(f"cmdline         : {cmdline.decode('utf-8', 'replace')}")

    if header_version >= 1:
        # v1: recovery_dtbo offset/size at offset 1632
        recovery_dtbo_offset = struct.unpack('<Q', data[1632:1640])[0]
        recovery_dtbo_size   = struct.unpack('<I', data[1640:1644])[0]
        boot_hdr_size        = struct.unpack('<I', data[1644:1648])[0]
        print(f"--- v1 fields ---")
        print(f"recovery_dtbo_offset : {hex(recovery_dtbo_offset)}")
        print(f"recovery_dtbo_size   : {recovery_dtbo_size}")
        print(f"boot_header_size     : {boot_hdr_size}")

    if header_version >= 2:
        # v2: dtb offset/size at 1648
        dtb_offset = struct.unpack('<Q', data[1648:1656])[0]
        dtb_size   = struct.unpack('<I', data[1656:1660])[0]
        print(f"--- v2 fields ---")
        print(f"dtb_offset           : {hex(dtb_offset)}")
        print(f"dtb_size             : {dtb_size}")

    # 文件大小
    import os
    print(f"file size       : {os.path.getsize(path)} ({hex(os.path.getsize(path))})")

if __name__ == '__main__':
    for p in sys.argv[1:]:
        analyze(p)
        print()
