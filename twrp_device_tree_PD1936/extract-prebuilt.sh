#!/bin/bash
# extract-prebuilt.sh
# 从已解包的 recovery.img ramdisk 自动拷贝 keymaster 解密链二进制到 prebuilt/
# 用法: ./extract-prebuilt.sh [recovery_extracted目录路径]
#
# 默认源: /workspace/recovery_extracted
# 默认目的: prebuilt/ (脚本所在目录)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="${1:-/workspace/recovery_extracted}"
DST="$SCRIPT_DIR/prebuilt"

if [ ! -d "$SRC" ]; then
    echo "错误: 源目录不存在: $SRC"
    echo "请先用 magiskboot/unpackbootimg 解包 recovery.img,得到 recovery_extracted 目录"
    exit 1
fi

echo "==> 源目录: $SRC"
echo "==> 目的目录: $DST"

# 创建目录结构
mkdir -p "$DST/system/bin"
mkdir -p "$DST/system/lib64"
mkdir -p "$DST/vendor/bin"
mkdir -p "$DST/vendor/lib64"
mkdir -p "$DST/recovery/root"

# ============= vendor/bin (keymaster/gatekeeper/qseecomd) =============
echo "==> 复制 vendor/bin ..."
for f in \
    vendor_bin_qseecomd \
    vendor_bin_android.hardware.gatekeeper@1.0-service-qti \
    vendor_bin_android.hardware.keymaster@4.0-service-qti
do
    src="$SRC/$f"
    if [ -f "$src" ]; then
        # 还原原始文件名
        dst_name="${f#vendor_bin_}"
        cp -v "$src" "$DST/vendor/bin/$dst_name"
        chmod 755 "$DST/vendor/bin/$dst_name"
    else
        echo "  警告: 缺失 $f"
    fi
done

# ============= system/bin (keystore/wait_for_keymaster/keystore_auth) =============
echo "==> 复制 system/bin ..."
for f in \
    system_bin_keystore \
    system_bin_keystore_auth \
    system_bin_wait_for_keymaster
do
    src="$SRC/$f"
    if [ -f "$src" ]; then
        dst_name="${f#system_bin_}"
        cp -v "$src" "$DST/system/bin/$dst_name"
        chmod 755 "$DST/system/bin/$dst_name"
    else
        echo "  警告: 缺失 $f"
    fi
done

# ============= system/lib64 (keymaster 库) =============
echo "==> 复制 system/lib64 ..."
for f in \
    system_lib64_android.hardware.gatekeeper@1.0.so \
    system_lib64_android.hardware.keymaster@3.0.so \
    system_lib64_android.hardware.keymaster@4.0.so \
    system_lib64_android.hardware.keymaster@4.1.so \
    system_lib64_android.system.wifi.keystore@1.0.so \
    system_lib64_libkeymaster4_1support.so \
    system_lib64_libkeymaster4support.so \
    system_lib64_libkeymaster_messages.so \
    system_lib64_libkeymaster_portable.so \
    system_lib64_libkeymasterdeviceutils.so \
    system_lib64_libkeymasterutils.so \
    system_lib64_libkeystore-attestation-application-id.so \
    system_lib64_libkeystore_aidl.so \
    system_lib64_libkeystore_binder.so \
    system_lib64_libkeystore_parcelables.so \
    system_lib64_libqtikeymaster4.so \
    system_lib64_libsoftkeymasterdevice.so \
    system_lib64_libvivogatekeeper.so \
    system_lib64_libwifikeystorehalext.so \
    system_lib64_vendor.vivo.hardware.wifi.keystore@1.0.so
do
    src="$SRC/$f"
    if [ -f "$src" ]; then
        dst_name="${f#system_lib64_}"
        cp -v "$src" "$DST/system/lib64/$dst_name"
        chmod 644 "$DST/system/lib64/$dst_name"
    else
        echo "  警告: 缺失 $f"
    fi
done

# ============= vendor/lib64 =============
echo "==> 复制 vendor/lib64 ..."
for f in \
    vendor_lib64_hw_android.hardware.gatekeeper@1.0-impl-qti.so \
    vendor_lib64_libQSEEComAPI.so \
    vendor_lib64_libkeystore-engine-wifi-hidl.so \
    vendor_lib64_libkeystore-wifi-hidl.so \
    vendor_lib64_vendor.vivo.hardware.wifi.keystore@1.0.so
do
    src="$SRC/$f"
    if [ -f "$src" ]; then
        # hw_android.hardware... -> hw/android.hardware...
        dst_name="${f#vendor_lib64_}"
        # 如果是 hw_xxx,创建 hw 子目录
        if [[ "$dst_name" == hw_* ]]; then
            mkdir -p "$DST/vendor/lib64/hw"
            dst_name="hw/${dst_name#hw_}"
        fi
        cp -v "$src" "$DST/vendor/lib64/$dst_name"
        chmod 644 "$DST/vendor/lib64/$dst_name"
    else
        echo "  警告: 缺失 $f"
    fi
done

# ============= sepolicy =============
echo "==> 复制 sepolicy ..."
if [ -f "$SRC/sepolicy" ]; then
    cp -v "$SRC/sepolicy" "$DST/../sepolicy/sepolicy_stocks"
fi

# ============= prop.default (用作参考) =============
echo "==> 复制 prop.default ..."
if [ -f "$SRC/prop.default" ]; then
    cp -v "$SRC/prop.default" "$DST/../prop.default"
fi

# ============= 复制 init.recovery.*.rc (用作参考,实际用我们改写的) =============
echo "==> 复制原始 .rc 文件 (作为参考)..."
mkdir -p "$DST/init_rc_original"
for f in \
    init.recovery.platform.rc \
    init.recovery.qcom.rc \
    init.recovery.svc.rc \
    init.recovery.touch.rc \
    init.recovery.wifi.rc \
    system_etc_init_hw_init.rc \
    system_etc_recovery.fstab \
    system_etc_ueventd.rc \
    ueventd.qcom.rc
do
    src="$SRC/$f"
    if [ -f "$src" ]; then
        cp -v "$src" "$DST/init_rc_original/$f"
    fi
done

echo ""
echo "==> 完成"
echo ""
echo "==> 接下来需要从 stock vendor.img 补充以下文件:"
echo "    vendor/bin/vendor.qti.hardware.cryptfshw@1.0-service-qti  (FBE 解密核心)"
echo "    vendor/lib64/libcryptfshw.so"
echo "    vendor/lib64/libcrypto-v32.so (或 libcrypto.so)"
echo "    vendor/lib64/libcutils.so"
echo "    vendor/lib64/liblog.so"
echo "    vendor/lib64/libhidlbase.so"
echo "    vendor/lib64/libutils.so"
echo "    vendor/lib64/libhardware.so"
echo ""
echo "==> 若缺少 cryptfshw,TWRP 无法解开 FBE 加密的 /data"
