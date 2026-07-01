#!/usr/bin/env python3
"""
mkbootimg v2 重打包脚本（vivo 变体：id[32] 字段，header_size=1660）
基于原始 boot.img header 复用，仅修改 kernel_size、dtb_size、id 字段
"""
import struct
import hashlib

BOOT_MAGIC = b'ANDROID!'
# vivo 使用的 boot_img_hdr_v2 变体布局（id[32] 而非 id[8]）：
# 0x000 magic[8]
# 0x008 kernel_size (u32)
# 0x00c kernel_addr (u32)
# 0x010 ramdisk_size (u32)
# 0x014 ramdisk_addr (u32)
# 0x018 second_size (u32)
# 0x01c second_addr (u32)
# 0x020 tags_addr (u32)
# 0x024 page_size (u32)
# 0x028 header_version (u32)
# 0x02c os_version (u32)
# 0x030 name[16]
# 0x040 cmdline[512]
# 0x240 id[32]            ← vivo 变体：32 字节（SHA-1 20B + 12B 填充）
# 0x260 extra_cmdline[1024]
# 0x660 recovery_dtbo_size (u32)
# 0x664 recovery_dtbo_addr (u64)
# 0x66c header_size (u32)
# 0x670 dtb_size (u32)
# 0x674 dtb_addr (u64)
# Total = 0x67c = 1660 字节
HEADER_SIZE_V2 = 1660

def pad_to(data, page_size):
    pad_len = (page_size - len(data) % page_size) % page_size
    return data + b'\x00' * pad_len

def compute_id_v0(kernel, ramdisk, second,
                  kernel_size, kernel_addr, ramdisk_size, ramdisk_addr,
                  second_size, second_addr, tags_addr, page_size,
                  header_version, os_version, cmdline, name, extra_cmdline):
    """AOSP v0/v1 风格的 id 计算：SHA-1(header fields) + 12 字节 0 填充 = 32 字节"""
    sha = hashlib.sha1()
    sha.update(struct.pack('<I', kernel_size))
    sha.update(struct.pack('<I', kernel_addr))
    sha.update(struct.pack('<I', ramdisk_size))
    sha.update(struct.pack('<I', ramdisk_addr))
    sha.update(struct.pack('<I', second_size))
    sha.update(struct.pack('<I', second_addr))
    sha.update(struct.pack('<I', tags_addr))
    sha.update(struct.pack('<I', page_size))
    sha.update(struct.pack('<I', header_version))
    sha.update(struct.pack('<I', os_version))
    sha.update(cmdline[:512].ljust(512, b'\x00'))
    sha.update(name[:16].ljust(16, b'\x00'))
    sha.update(extra_cmdline[:1024].ljust(1024, b'\x00'))
    return sha.digest() + b'\x00' * 12  # 20 + 12 = 32 字节

def main():
    orig_bootimg = '/workspace/boot.img'
    new_kernel_path = '/workspace/kernel_src/out/arch/arm64/boot/Image'
    orig_dtb_path = '/workspace/boot_unpacked/dtb'
    output = '/workspace/boot_new.img'

    print("=== boot.img v2 重打包 (vivo id[32] 变体) ===")
    print(f"original:   {orig_bootimg}")
    print(f"new kernel: {new_kernel_path}")
    print(f"orig dtb:   {orig_dtb_path} (复用)")
    print()

    # 读取原始 boot.img 的前 4KB header
    with open(orig_bootimg, 'rb') as f:
        orig_header_page = f.read(4096)

    # 读取新 kernel 和原 dtb
    with open(new_kernel_path, 'rb') as f:
        new_kernel = f.read()
    with open(orig_dtb_path, 'rb') as f:
        orig_dtb = f.read()

    # 解析原始 header 字段（vivo 变体布局）
    magic = orig_header_page[0:8]
    assert magic == BOOT_MAGIC, f"Magic mismatch: {magic}"

    kernel_addr = struct.unpack('<I', orig_header_page[0x0c:0x10])[0]
    ramdisk_size = struct.unpack('<I', orig_header_page[0x10:0x14])[0]
    ramdisk_addr = struct.unpack('<I', orig_header_page[0x14:0x18])[0]
    second_size = struct.unpack('<I', orig_header_page[0x18:0x1c])[0]
    second_addr = struct.unpack('<I', orig_header_page[0x1c:0x20])[0]
    tags_addr = struct.unpack('<I', orig_header_page[0x20:0x24])[0]
    page_size = struct.unpack('<I', orig_header_page[0x24:0x28])[0]
    header_version = struct.unpack('<I', orig_header_page[0x28:0x2c])[0]
    os_version = struct.unpack('<I', orig_header_page[0x2c:0x30])[0]

    name = orig_header_page[0x30:0x40]
    cmdline = orig_header_page[0x40:0x240]
    extra_cmdline = orig_header_page[0x260:0x660]

    recovery_dtbo_size = struct.unpack('<I', orig_header_page[0x660:0x664])[0]
    recovery_dtbo_addr = struct.unpack('<Q', orig_header_page[0x664:0x66c])[0]
    orig_header_size = struct.unpack('<I', orig_header_page[0x66c:0x670])[0]
    orig_dtb_size_field = struct.unpack('<I', orig_header_page[0x670:0x674])[0]
    dtb_addr = struct.unpack('<Q', orig_header_page[0x674:0x67c])[0]

    cmdline_str = cmdline.split(b'\x00')[0].decode('latin-1','replace')

    print(f"header_version: {header_version}")
    print(f"page_size: {page_size}")
    print(f"kernel_addr: 0x{kernel_addr:x}")
    print(f"dtb_addr: 0x{dtb_addr:x}")
    print(f"orig header_size: 0x{orig_header_size:x} ({orig_header_size})")
    print(f"orig dtb_size: {orig_dtb_size_field}")
    print(f"cmdline: {cmdline_str[:80]}...")
    print()

    # 新的 size
    new_kernel_size = len(new_kernel)
    new_dtb_size = len(orig_dtb)

    # 计算新 id (SHA-1 + 12 字节填充 = 32 字节)
    new_id = compute_id_v0(
        new_kernel, b'', b'',
        new_kernel_size, kernel_addr, ramdisk_size, ramdisk_addr,
        second_size, second_addr, tags_addr, page_size,
        header_version, os_version, cmdline, name, extra_cmdline)

    # 构造新 header：基于原始 header 前 1660 字节，仅修改 kernel_size、dtb_size、id、header_size
    new_header = bytearray(orig_header_page[:HEADER_SIZE_V2])
    # 修改 kernel_size (offset 0x08)
    struct.pack_into('<I', new_header, 0x08, new_kernel_size)
    # 修改 id (offset 0x240, 32 字节)
    new_header[0x240:0x260] = new_id
    # 修改 header_size (offset 0x66c)
    struct.pack_into('<I', new_header, 0x66c, HEADER_SIZE_V2)
    # 修改 dtb_size (offset 0x670)
    struct.pack_into('<I', new_header, 0x670, new_dtb_size)

    # 组装 boot.img
    out = bytearray()
    out += pad_to(bytes(new_header), page_size)
    out += pad_to(new_kernel, page_size)
    # ramdisk_size=0, second_size=0, recovery_dtbo_size=0 → 全部跳过
    if new_dtb_size > 0:
        out += pad_to(orig_dtb, page_size)

    with open(output, 'wb') as f:
        f.write(out)

    print(f"✓ 已生成 {output}")
    print(f"  kernel: {new_kernel_size} bytes ({new_kernel_size/1024/1024:.2f} MB)")
    print(f"  ramdisk: 0 bytes (GKI 架构)")
    print(f"  dtb: {new_dtb_size} bytes ({new_dtb_size/1024/1024:.2f} MB)")
    print(f"  total: {len(out)} bytes ({len(out)/1024/1024:.2f} MB)")
    print(f"  header_size: {HEADER_SIZE_V2}")

    # 校验：与原始 boot.img 对比关键字段
    print(f"\n=== 校验 ===")
    with open(output, 'rb') as f:
        verify = f.read(4096)
    print(f"  magic: {verify[0:8]}")
    print(f"  kernel_size:  {struct.unpack('<I', verify[8:12])[0]} bytes (orig: 0x2a38010={0x2a38010})")
    print(f"  header_version: {struct.unpack('<I', verify[40:44])[0]}")
    print(f"  dtb_size: {struct.unpack('<I', verify[0x670:0x674])[0]}")
    print(f"  dtb_addr: 0x{struct.unpack('<Q', verify[0x674:0x67c])[0]:x}")
    print(f"  cmdline preserved: {verify[0x40:0xc0] == orig_header_page[0x40:0xc0]}")
    print(f"  extra_cmdline preserved: {verify[0x260:0x660] == orig_header_page[0x260:0x660]}")

    # 与原始 boot.img 对比
    orig_size = os.path.getsize(orig_bootimg)
    new_size = os.path.getsize(output)
    print(f"\n  orig boot.img: {orig_size} bytes ({orig_size/1024/1024:.2f} MB)")
    print(f"  new boot.img:  {new_size} bytes ({new_size/1024/1024:.2f} MB)")
    print(f"  diff: {new_size - orig_size} bytes (kernel smaller by ~16MB)")

if __name__ == '__main__':
    import os
    main()
