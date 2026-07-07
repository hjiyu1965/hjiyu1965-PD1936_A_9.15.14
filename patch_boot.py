#!/usr/bin/env python3
"""
vivo PD1936 (iQOO Neo 855, SM8150) 内核 patch 脚本
=====================================================
对原厂 boot.img 做二进制 patch，绕过 vivo 4 层防护 + SELinux + dm-verity，
解决以下问题：
  - dd /dev/block/by-name/boot Permission denied  (vs_block TEE 写保护)
  - SELinux enforcing 无法关闭
  - inode/file 权限 hook 拦截
  - vivo 私有块设备 hook (_vrpb_1_v_r_s_h_s)
  - mount -o remount,rw /vendor Operation not permitted (dm-verity)

共 13 处 patch：
  Patches 1-11 : 原 11 处（已验证修复 dd 读写 boot）
  Patch  12    : bdev_read_only -> ret 0   (允许 remount,rw /vendor)
  Patch  13    : verity_end_io  -> ret 0   (跳过 dm-verity 哈希校验)

用法：
  python3 patch_boot.py <input_boot.img> [output_boot.img]

  默认输出文件名：boot_patched.img
"""
import sys
import os
import struct

# ============================================================================
# 内核加载虚拟地址基址（arm64 Image 文本段起始虚拟地址）
# ============================================================================
VBASE = 0xffffff8008080000

# ============================================================================
# boot.img 头部参数（从 header 解析，下方运行时校验）
# ============================================================================
# 对本固件：page_size=4096, kernel 起始位于 boot.img 偏移 0x1000
# boot_off = page_size + (vaddr - VBASE)
# ============================================================================

# ----------------------------------------------------------------------------
# 13 处 patch 列表
#   (描述, 虚拟地址, 原始字节, patch 字节)
# ----------------------------------------------------------------------------
PATCHES = [
    # ---- 第 1 组：SELinux 强制关闭 ------------------------------------------
    ('1. SELinux permissive (sel_write_enforce -> always 1)',
     0xffffff80084a3f30,
     b'\xe8\x07\x9f\x1a',                 #orr w8, wzr, #0x1  (读取 enforcing)
     b'\xe8\x03\x1f\x2a'),                #mov w8, wzr        -> 实际仍配合下面让 sel_write_enforce 写入但 enforcing 保持
                                            # 这里直接让 w8=1 改为 wzr... 见注释：原本 orr w8,wzr,#1
                                            # patch 为 mov w8, wzr，使 selinux 始终 permissive 写法保留
                                            # （注：此 patch 让写入 enforcing 总返回成功且保持 permissive）

    # ---- 第 2 组：vs_block TEE 写保护绕过（boot 分区可写）------------------
    ('2. vs_block set_disk_ro 绕过 (boot 分区可写)',
     0xffffff80088f3c78,
     b'\x28\x6b\x68\x38',                 #ldrb w8, [x25, #0x1a]
     b'\xe8\x03\x1f\x2a'),                #mov w8, wzr  -> 不读取只读标志

    ('3. vs_block -EROFS 绕过 (消除只读返回)',
     0xffffff80088f5230,
     b'\xe8\x02\x40\x39',                 #ldrb w8, [x23]
     b'\xe8\x03\x1f\x2a'),                #mov w8, wzr  -> 不返回 EROFS

    # ---- 第 3 组：LSM hook 绕过（inode/file 权限）--------------------------
    ('4. security_inode_permission -> ret 0',
     0xffffff8008493440,
     b'\xfd\x7b\xbd\xa9\xf6\x57\x01\xa9', #stp x29,x30; stp x22,x21
     b'\xe0\x03\x1f\x2a\xc0\x03\x5f\xd6'),#mov w0, wzr; ret

    ('5. security_file_open -> ret 0',
     0xffffff8008494210,
     b'\xfd\x7b\xbd\xa9\xf6\x57\x01\xa9', #stp x29,x30; stp x22,x21
     b'\xe0\x03\x1f\x2a\xc0\x03\x5f\xd6'),#mov w0, wzr; ret

    ('6. __inode_permission2 -> ret 0',
     0xffffff80082b8b50,
     b'\xfd\x7b\xbd\xa9\xf5\x0b\x00\xf9', #stp x29,x30; stp x21,x20
     b'\xe0\x03\x1f\x2a\xc0\x03\x5f\xd6'),#mov w0, wzr; ret

    # ---- 第 4 组：may_open 权限检查绕过 -------------------------------------
    ('7. may_open tbnz1 -> nop (跳过权限检查分支)',
     0xffffff80082c1050,
     b'\xaa\x03\x08\x37',                 #tbnz w10, #1, ...
     b'\x1f\x20\x03\xd5'),                #nop

    ('8. may_open tbnz2 -> nop',
     0xffffff80082c105c,
     b'\x4a\x03\x10\x37',                 #tbnz w10, #2, ...
     b'\x1f\x20\x03\xd5'),                #nop

    # ---- 第 5 组：__blkdev_get 块设备打开权限绕过 ---------------------------
    ('9. __blkdev_get: mov w25, w0 -> mov w25, wzr (忽略权限返回值)',
     0xffffff80082f8afc,
     b'\xf9\x03\x00\x2a',                 #mov w25, w0
     b'\xf9\x03\x1f\x2a'),                #mov w25, wzr

    ('10. __blkdev_get: cbnz w0 -> nop (不因权限失败跳转)',
     0xffffff80082f8b00,
     b'\x00\x05\x00\x35',                 #cbnz w0, ...
     b'\x1f\x20\x03\xd5'),                #nop

    # ---- 第 6 组：vivo 私有块设备 hook 绕过 ---------------------------------
    ('11. _vrpb_1_v_r_s_h_s -> ret 0 (vivo 块设备拦截 hook)',
     0xffffff8008483620,
     b'\xff\x03\x01\xd1\xfd\x7b\x02\xa9', #sub sp,sp,#0x40; stp x29,x30
     b'\xe0\x03\x1f\x2a\xc0\x03\x5f\xd6'),#mov w0, wzr; ret

    # ---- 第 7 组：dm-verity 绕过（允许 remount,rw /vendor）-----------------
    # Patch 12: bdev_read_only 总返回 0（可写）
    #   原函数：cbz x0, +12; ldr x8, [x0,#0x80]; ldr w0,[x8,#0x338]; ret
    #   remount 路径调用 bdev_read_only 判断块设备是否只读，强制返回 0 = 可写
    ('12. bdev_read_only -> ret 0 (dm-verity 只读绕过, 允许 remount,rw)',
     0xffffff8008515ba8,
     b'\x60\x00\x00\xb4\x08\x40\x40\xf9', #cbz x0, +12; ldr x8, [x0, #0x80]
     b'\xe0\x03\x1f\x2a\xc0\x03\x5f\xd6'),#mov w0, wzr; ret

    # Patch 13: verity_end_io 总返回 0（跳过所有哈希校验）
    #   原函数：stp x29,x30; stp x20,x19; ... -> 调用 verity_fec_finish_io / verity_verify_io
    #   patch 为直接 ret 0，跳过所有哈希验证
    #   verity_map 仍正常设置 verity_io 并提交 bio，但 end_io 不做验证 -> 写入不会被 verity 拒绝
    ('13. verity_end_io -> ret 0 (跳过 dm-verity 哈希验证)',
     0xffffff8008ddc030,
     b'\xfd\x7b\xbe\xa9\xf4\x4f\x01\xa9', #stp x29,x30,[sp,#-0x20]!; stp x20,x19,[sp,#0x10]
     b'\xe0\x03\x1f\x2a\xc0\x03\x5f\xd6'),#mov w0, wzr; ret
]

# ----------------------------------------------------------------------------
# 等价 patch 编码识别
#   在已部分 patch 的 boot.img 上再次运行时，原始字节会变成这些等价编码，
#   仍然视为"已 patch"，避免误报 FAIL。
# ----------------------------------------------------------------------------
EQUIV_PATCHES = {
    # Patch 5: security_file_open 可能用 mov w0,#0; ret（000080d2 c0035fd6）
    #          等价于 mov w0,wzr; ret（e0031f2a c0035fd6）
    0xffffff8008494210: [b'\x00\x00\x80\xd2\xc0\x03\x5f\xd6'],
    # Patch 6: __inode_permission2 同理
    0xffffff80082b8b50: [b'\x00\x00\x80\xd2\xc0\x03\x5f\xd6'],
    # Patch 12: bdev_read_only 用 mov w0,#0; ret
    0xffffff8008515ba8: [b'\x00\x00\x80\xd2\xc0\x03\x5f\xd6'],
    # Patch 13: verity_end_io 用 mov w0,#0; ret
    0xffffff8008ddc030: [b'\x00\x00\x80\xd2\xc0\x03\x5f\xd6'],
}


def parse_boot_header(data):
    """解析 Android boot.img 头部，返回 (page_size, kernel_off, kernel_size)"""
    if data[0:8] != b'ANDROID!':
        raise ValueError("不是 Android boot.img (magic 错误)")

    kernel_size  = struct.unpack('<I', data[8:12])[0]
    page_size    = struct.unpack('<I', data[36:40])[0]
    header_ver   = struct.unpack('<I', data[40:44])[0]

    # kernel 紧跟 header 之后，header 占 1 个 page
    # （v0/v1/v2 都是 1 page header）
    kernel_off = page_size

    return page_size, kernel_off, kernel_size, header_ver


def vaddr_to_boot_off(vaddr, kernel_off):
    """虚拟地址 -> boot.img 内偏移"""
    return kernel_off + (vaddr - VBASE)


def main():
    if len(sys.argv) < 2:
        print("用法: python3 patch_boot.py <input_boot.img> [output_boot.img]")
        sys.exit(1)

    in_path = sys.argv[1]
    out_path = sys.argv[2] if len(sys.argv) >= 3 else 'boot_patched.img'

    if not os.path.exists(in_path):
        print(f"错误: 输入文件不存在: {in_path}")
        sys.exit(1)

    with open(in_path, 'rb') as f:
        data = bytearray(f.read())

    print(f"输入: {in_path} ({len(data)} 字节)")
    print()

    # 解析 header
    page_size, kernel_off, kernel_size, header_ver = parse_boot_header(data)
    print(f"boot.img header: page_size={page_size} kernel_off={kernel_off:#x} "
          f"kernel_size={kernel_size} header_version={header_ver}")
    print()

    # 校验 kernel 区域
    kernel_end = kernel_off + kernel_size
    if kernel_end > len(data):
        print(f"错误: kernel 区域超出文件范围 (kernel_end={kernel_end:#x}, file_size={len(data):#x})")
        sys.exit(1)

    print(f"kernel 区域: {kernel_off:#x} - {kernel_end:#x} ({kernel_size} 字节)")
    print(f"VBASE = {VBASE:#018x}")
    print()

    # 应用 patch
    print("=" * 78)
    print("应用 13 处 patch")
    print("=" * 78)

    success = 0
    failed  = 0
    already = 0

    for desc, vaddr, orig, patch in PATCHES:
        boff = vaddr_to_boot_off(vaddr, kernel_off)
        actual = bytes(data[boff:boff + len(orig)])

        if actual == patch:
            # 已经 patch 过
            print(f"  [ALREADY] {desc}")
            print(f"            vaddr={vaddr:#018x} boot_off={boff:#010x}")
            already += 1

        elif actual == orig:
            # 应用 patch
            data[boff:boff + len(patch)] = patch
            print(f"  [ OK    ] {desc}")
            print(f"            vaddr={vaddr:#018x} boot_off={boff:#010x}")
            print(f"            {orig.hex()} -> {patch.hex()}")
            success += 1

        elif vaddr in EQUIV_PATCHES and actual in EQUIV_PATCHES[vaddr]:
            # 等价编码（之前用 mov w0,#0; ret 等）
            print(f"  [EQUIV ] {desc}")
            print(f"            vaddr={vaddr:#018x} boot_off={boff:#010x}")
            print(f"            当前={actual.hex()} (等价于 patch, 视为已应用)")
            already += 1

        else:
            # 原始字节不匹配（固件版本不对？）
            print(f"  [ FAIL  ] {desc}")
            print(f"            vaddr={vaddr:#018x} boot_off={boff:#010x}")
            print(f"            期望原始={orig.hex()}")
            print(f"            实际字节={actual.hex()}")
            failed += 1

    print()
    print("=" * 78)
    print(f"结果: 成功 {success} / 已应用 {already} / 失败 {failed} / 共 {len(PATCHES)}")
    print("=" * 78)

    if failed > 0:
        print()
        print("WARNING: 部分 patch 失败, 请检查固件版本!")
        print("        失败的 patch 未应用, 输出文件仍生成但可能不完整。")

    # 写出
    with open(out_path, 'wb') as f:
        f.write(data)

    print()
    print(f"输出: {out_path} ({len(data)} 字节)")
    print()
    print("刷入命令（设备端，需 root + 解锁 / 或用 fastboot）：")
    print(f"  dd if={out_path} of=/dev/block/by-name/boot")
    print("或")
    print(f"  fastboot flash boot {out_path}")


if __name__ == '__main__':
    main()
