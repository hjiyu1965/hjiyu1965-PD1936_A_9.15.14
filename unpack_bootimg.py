#!/usr/bin/env python3
"""Unpack Android boot image (legacy v0/v1/v2)."""
import struct
import os
import sys

def parse_and_unpack(path, out_dir):
    with open(path, 'rb') as f:
        header = f.read(4096)  # read full first page to be safe

    magic = header[:8]
    if magic != b'ANDROID!':
        print(f'Not an Android boot image: magic={magic!r}')
        sys.exit(1)

    (kernel_size, kernel_addr, ramdisk_size, ramdisk_addr,
     second_size, second_addr, tags_addr, page_size,
     header_version, os_version) = struct.unpack('<10I', header[8:48])

    name = header[48:64].rstrip(b'\x00').decode('utf-8', 'replace')
    cmdline = header[64:576].rstrip(b'\x00').decode('utf-8', 'replace')
    # id[8] = header[576:608]
    extra_cmdline = header[608:1632].rstrip(b'\x00').decode('utf-8', 'replace')

    recovery_dtbo_size = 0
    recovery_dtbo_addr = 0
    boot_size = 0
    dtb_size = 0
    dtb_addr = 0

    # v1 layout: recovery_dtbo_size(u32) @1632, recovery_dtbo_addr(u64) @1636
    if header_version >= 1:
        recovery_dtbo_size, recovery_dtbo_addr = struct.unpack('<IQ', header[1632:1644])
    # v2 layout: boot_size(u32) @1644, dtb_size(u32) @1648, dtb_addr(u64) @1652
    if header_version >= 2:
        boot_size, dtb_size, dtb_addr = struct.unpack('<IIQ', header[1644:1660])

    print('=== Boot Image Header ===')
    print(f'header_version:      {header_version}')
    print(f'page_size:           {page_size}')
    print(f'kernel_size:         {kernel_size}')
    print(f'kernel_addr:         0x{kernel_addr:08x}')
    print(f'ramdisk_size:        {ramdisk_size}')
    print(f'ramdisk_addr:        0x{ramdisk_addr:08x}')
    print(f'second_size:         {second_size}')
    print(f'second_addr:         0x{second_addr:08x}')
    print(f'tags_addr:           0x{tags_addr:08x}')
    print(f'os_version:          0x{os_version:08x}')
    print(f'name:                {name!r}')
    print(f'cmdline:             {cmdline!r}')
    print(f'extra_cmdline:       {extra_cmdline!r}')
    if header_version >= 1:
        print(f'recovery_dtbo_size:  {recovery_dtbo_size}')
        print(f'recovery_dtbo_addr:  0x{recovery_dtbo_addr:016x}')
    if header_version >= 2:
        print(f'boot_size:           {boot_size}')
        print(f'dtb_size:            {dtb_size}')
        print(f'dtb_addr:            0x{dtb_addr:016x}')

    os.makedirs(out_dir, exist_ok=True)

    def pages(size):
        return (size + page_size - 1) // page_size

    with open(path, 'rb') as f:
        # Header occupies 1 page
        f.seek(page_size)

        def read_section(size):
            if size == 0:
                return b''
            data = f.read(size)
            # skip to next page boundary
            pad = (page_size - (size % page_size)) % page_size
            f.read(pad)
            return data

        kernel = read_section(kernel_size)
        ramdisk = read_section(ramdisk_size)
        second = read_section(second_size)
        recovery_dtbo = read_section(recovery_dtbo_size) if header_version >= 1 else b''
        dtb = read_section(dtb_size) if header_version >= 2 else b''

    # Write extracted files
    def write_file(name, data):
        path_out = os.path.join(out_dir, name)
        with open(path_out, 'wb') as o:
            o.write(data)
        print(f'  -> wrote {name}: {len(data)} bytes')

    print('\n=== Extracted Files ===')
    if kernel_size:
        write_file('kernel', kernel)
        # Also save as kernel.gz if it's compressed (try detecting)
        if kernel[:4] == b'\x1f\x8b\x08\x00' or kernel[:2] in (b'\x5d\x00', b'\x42\x5a\x68'):
            write_file('kernel.gz', kernel)  # gzip/lzma/bz2 wrapped
    if ramdisk_size:
        write_file('ramdisk', ramdisk)
    if second_size:
        write_file('second', second)
    if recovery_dtbo_size:
        write_file('recovery_dtbo', recovery_dtbo)
    if dtb_size:
        write_file('dtb', dtb)

    # Write header info for repacking
    info_path = os.path.join(out_dir, 'header.txt')
    with open(info_path, 'w') as o:
        o.write(f'page_size={page_size}\n')
        o.write(f'header_version={header_version}\n')
        o.write(f'kernel_addr=0x{kernel_addr:08x}\n')
        o.write(f'ramdisk_addr=0x{ramdisk_addr:08x}\n')
        o.write(f'second_addr=0x{second_addr:08x}\n')
        o.write(f'tags_addr=0x{tags_addr:08x}\n')
        o.write(f'os_version=0x{os_version:08x}\n')
        o.write(f'name={name}\n')
        o.write(f'cmdline={cmdline}\n')
        o.write(f'extra_cmdline={extra_cmdline}\n')
        if header_version >= 1:
            o.write(f'recovery_dtbo_addr=0x{recovery_dtbo_addr:016x}\n')
        if header_version >= 2:
            o.write(f'dtb_addr=0x{dtb_addr:016x}\n')
    print(f'  -> wrote header.txt')

if __name__ == '__main__':
    src = sys.argv[1] if len(sys.argv) > 1 else '/workspace/boot.img'
    out = sys.argv[2] if len(sys.argv) > 2 else '/workspace/boot_unpacked'
    parse_and_unpack(src, out)
