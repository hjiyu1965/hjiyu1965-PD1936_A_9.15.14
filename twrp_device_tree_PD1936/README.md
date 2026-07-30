# TWRP Device Tree for iQOO PD1936 (V1936A)

基于官方 `recovery.img` 制作的最小可编译 TWRP 设备树,支持 FBE 解密。

## 设备信息

| 项目 | 内容 |
|------|------|
| 机型代号 | PD1936 |
| 销售型号 | V1936A (iQOO) |
| 品牌 | vivo / iQOO |
| 平台 | Qualcomm SM8150 / msmnile |
| Android | 11 (SDK 30) |
| Kernel | 4.14.190-perf |
| Boot header | v2 |
| 加密 | FBE f2fs + ICE + wrappedkey |
| Keymaster | 4.0 (QTI) |
| A/B | 否 (A-only) |
| System-as-root | 是 |

## 设备树结构

```
twrp_device_tree_PD1936/
├── AndroidProducts.mk          # 产品入口
├── omni_PD1936.mk              # 产品配置
├── BoardConfig.mk              # 板级配置
├── device.mk                   # 设备模块配置
├── Android.mk                  # 编译规则
├── recovery.fstab              # TWRP 分区表
├── extract-prebuilt.sh         # 自动提取 keymaster 解密链脚本
├── extract-kernel.sh           # 从 recovery.img 提取 kernel 脚本
├── README.md                   # 本文件
├── recovery/root/              # init.recovery.*.rc 配置
│   ├── init.recovery.rc
│   ├── init.recovery.qcom.rc   # keymaster 解密链服务定义
│   ├── init.recovery.svc.rc
│   ├── init.recovery.platform.rc
│   ├── init.recovery.touch.rc
│   ├── init.recovery.wifi.rc
│   ├── init.recovery.usb.rc
│   └── ueventd.qcom.rc
├── prebuilt/                   # 预编译二进制 (由 extract-*.sh 填充)
│   ├── kernel                  # kernel.elf (extract-kernel.sh)
│   ├── system/bin/
│   ├── system/lib64/
│   ├── vendor/bin/
│   └── vendor/lib64/
└── sepolicy/                   # SELinux 策略
    ├── recovery.te             # recovery 域放行规则
    └── file_contexts           # 二进制文件标签
```

## 编译前准备

### 1. 准备源码

需要 TWRP 源码 (基于 AOSP 11),支持的关键版本:

- **TWRP 3.7.x** (推荐,支持 wrappedkey)
- OmniROM TWRP manifest (https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp)

```bash
mkdir -p ~/twrp
cd ~/twrp
repo init -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-11
repo sync -c -j8
```

### 2. 放置设备树

```bash
mkdir -p device/vivo/PD1936
cp -r twrp_device_tree_PD1936/* device/vivo/PD1936/
```

### 3. 提取 kernel 与解密链二进制

```bash
cd device/vivo/PD1936

# 从 recovery.img 提取 kernel
./extract-kernel.sh /path/to/recovery.img

# 从已解包的 recovery ramdisk 提取 keymaster 库
# (假设 recovery.img 已经用 magiskboot 解包到 /workspace/recovery_extracted)
./extract-prebuilt.sh /workspace/recovery_extracted
```

### 4. ⚠️ 必须补充 cryptfshw (FBE 解密核心)

`recovery.img` 不包含 `cryptfshw-1-0` 服务,因为它原本由 vendor 分区提供。
必须从 stock vendor.img 提取以下文件,放入 prebuilt/ 对应目录:

```bash
# 假设 vendor.img 已挂载到 /mnt/vendor
cp /mnt/vendor/bin/vendor.qti.hardware.cryptfshw@1.0-service-qti prebuilt/vendor/bin/
cp /mnt/vendor/lib64/libcryptfshw.so prebuilt/vendor/lib64/

# 可能依赖的库(根据 link 检查)
# 用 readelf -d 检查 libcryptfshw.so 依赖,缺失的也拷过来
```

> **没有 cryptfshw 就解不开 FBE**,`/data` 里依然是加密乱码。

### 5. 编译

```bash
cd ~/twrp
source build/envsetup.sh
lunch omni_PD1936-userdebug
mka recoveryimage -j8
```

输出: `out/target/product/PD1936/recovery.img`

## 关键配置说明

### FBE 解密链 (核心)

`recovery.fstab` 中 userdata 行 **必须**保留:

```
fileencryption=ice,wrappedkey
```

启动流程 (init.recovery.qcom.rc):

```
early-boot
  ├── start qseecomd              # QSEE 守护
  └── start cryptfshw-1-0         # 高通 FBE 解密 HAL

on property:recovery.service=1
  ├── start keymaster-4-0         # Keymaster 4.0 HIDL
  ├── start gatekeeper-1-0        # Gatekeeper
  ├── exec_start wait_for_keymaster  # 等待 keymaster ready
  ├── start guardianangle         # vivo 守护
  └── setprop recovery.state.services.ready 1
```

### SELinux

默认 TWRP 是 permissive,但若启用了 enforcing,需要 [sepolicy/recovery.te](sepolicy/recovery.te) 中的规则放行 recovery 域访问 qseecom/tee/keymaster。

## 故障排查

### 1. /data 显示乱码 (FBE 未解密)

进 TWRP 后 adb shell:

```bash
getprop init.svc.keymaster-4-0       # 应为 running
getprop init.svc.qseecomd            # 应为 running
getprop init.svc.cryptfshw-1-0       # 应为 running
getprop recovery.state.services.ready # 应为 1

# 看日志
logcat -d | grep -E 'keymaster|qseecomd|cryptfshw|vold'
dmesg | grep -i qsee
```

如服务 stopped:
- 检查 `sbin/` 下二进制是否存在
- `logcat | grep avc` 检查 SELinux 拒绝
- 检查依赖库:`readelf -d sbin/qseecomd` 看缺哪个 .so

### 2. keymaster 起不来

```bash
# 在 TWRP shell 里手动跑,看错误
/sbin/qseecomd
/sbin/android.hardware.keymaster@4.0-service-qti
```

常见原因:
- 缺 libQSEEComAPI.so → 检查 vendor/lib64/
- 缺 libcutils/libhidlbase → 检查 system/lib64/
- SELinux 拒绝 → 看 `logcat | grep avc`,补 recovery.te 规则

### 3. 触摸不灵

设备用 FTS/NVT/Goodix 多家 TP IC,kernel 驱动自带,不需要 firmware 升级即可触摸。如确实不灵:
- 检查 `/dev/input/event*` 节点
- `getevent -p` 看哪个设备上报

### 4. 屏幕黑屏

```bash
# 设置背光
echo 200 > /sys/class/backlight/panel0-backlight/brightness
```

如完全黑屏 (UI 不显示),改 `BoardConfig.mk`:
```
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
# 或尝试 BGRA_8888 / RGBA_8888
```

## 已知问题

1. **cryptfshw 不在 recovery.img 中** — 必须从 vendor.img 提取
2. **vts_app_recovery (触摸固件升级)** 未集成 — 触摸本身可用,固件升级功能缺失
3. **guardianangle** 二进制不在 recovery.img 中 — 如启动失败可注释掉 init.recovery.qcom.rc 中对应行

## 参考来源

- 解包分析: `recovery_extracted/`
- 官方 recovery.fstab: [system_etc_recovery.fstab](file:///workspace/recovery_extracted/system_etc_recovery.fstab)
- 官方 init.rc: [system_etc_init_hw_init.rc](file:///workspace/recovery_extracted/system_etc_init_hw_init.rc)
- 属性: [prop.default](file:///workspace/recovery_extracted/prop.default)
- kernel 配置: [recovery_kernel_config.txt](file:///workspace/recovery_kernel_config.txt)

## License

设备树中含 Qualcomm/Linux Foundation 的版权声明(原 fstab/rc),其余为 TWRP 设备树常规 MIT 风格使用。
