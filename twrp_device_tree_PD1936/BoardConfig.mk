# BoardConfig.mk for iQOO PD1936 (V1936A)
# Platform: Qualcomm SM8150 / msmnile
# Source: recovery.img header + kernel_config

DEVICE_PATH := device/vivo/PD1936

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a76
TARGET_CPU_VARIANT_RUNTIME := cortex-a76

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a76
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a76

ENABLE_CPUSETS := true
ENABLE_SCHEDBOOST := true

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := msmnile
TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true

# Platform
TARGET_BOARD_PLATFORM := msmnile
TARGET_BOARD_PLATFORM_GPU := qcom-adreno640
QCOM_BOARD_PLATFORMS += msmnile

# Kernel
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_CLANG_COMPILE := true
TARGET_KERNEL_CROSS_COMPILE_PREFIX := aarch64-linux-android-
TARGET_LINUX_KERNEL_VERSION := 4.14

# Use prebuilt kernel from recovery.img (since we don't have kernel source)
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
BOARD_KERNEL_IMAGE_NAME := Image
TARGET_KERNEL_SOURCE := none

# Boot image header
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x01000000
BOARD_SECOND_OFFSET := 0x00f00000
BOARD_TAGS_OFFSET := 0x00000100
BOARD_DTB_OFFSET := 0x01f00000
BOARD_KERNEL_CMDLINE := console=null earlycon=null androidboot.hardware=qcom androidboot.memcg=1 lpm_levels.sleep_disabled=1 video=vfb:640x400,bpp=32,memsize=3072000 msm_rtb.filter=0x237 service_locator.enable=1 swiotlb=2048
BOARD_MKBOOTIMG_ARGS := --kernel_offset $(BOARD_KERNEL_OFFSET) --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --second_offset $(BOARD_SECOND_OFFSET) --tags_offset $(BOARD_TAGS_OFFSET) --dtb_offset $(BOARD_DTB_OFFSET) --header_version 2

# Android boot image v2
BOARD_BOOT_HEADER_VERSION := 2
BOARD_USES_RECOVERY_AS_BOOT := false

# Partition layout
BOARD_FLASH_BLOCK_SIZE := 262144  # 4096 * 64

# System-as-root (from ro.build.system_root_image=true)
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
BOARD_USES_SYSTEM_AS_ROOT_IMAGE := true
AB_OTA_UPDATER := false

# Filesystems
BOARD_SYSTEMIMAGE_PARTITION_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4

# Read-only partitions mounted via first stage init in real system; for recovery we use fstab
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_ODM := odm
TARGET_COPY_OUT_PRODUCT := product

# File-based encryption (CRITICAL - do not change)
BOARD_USES_METADATA_PARTITION := true
BOARD_USES_QCOM_FBE_DECRYPTION := true
TARGET_CRYPTFS_HW_PATH := vendor/qcom/opensource/cryptfs_hw
TARGET_KEYMASTER_VARIANT := qti
TARGET_USES_HARDWARE_QCOM_BOOTCTRL := false

# TWRP
TW_THEME := portrait_hdpi
TW_DEVICE_VERSION := PD1936_TWRP
RECOVERY_VARIANT := twrp
TW_USE_MODEL_HARDWARE_ID_FOR_DEVICE_ID := true

# Recovery GUI
TW_BRIGHTNESS_PATH := /sys/class/backlight/panel0-backlight/brightness
TW_DEFAULT_BRIGHTNESS := 200
TW_MAX_BRIGHTNESS := 1023
TW_SCREEN_BLANK_ON_BOOT := true
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_LCD_BACKLIGHT_PATH := /sys/class/backlight/panel0-backlight/brightness

# TWRP features
TW_INCLUDE_NTFS_3G := true
TW_INCLUDE_FUSE_EXFAT := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LIBRESETPROP := true
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_FASTBOOTD := false  # device is A-only, no fastbootd
TW_EXTRA_LANGUAGES := true
TW_NO_LEGACY_PROPS := true
TW_USE_TOOLBOX := true
TW_NO_BIND_SYSTEM := true
TW_NO_SCREEN_TIMEOUT := true
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
TW_INCLUDE_QTI_FBE_DECRYPT := true
TW_FORCE_CREATE_METADATA := true

# TWRP flags for qcom
TW_FORCE_KEYMASTER_VER := true
TARGET_USES_KEYMASTER_4 := true
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery.fstab

# Graphics
TARGET_USES_HWC2 := true
TARGET_USES_DRM_HWCOMPOSER := true
TARGET_USES_GRALLOC4 := true

# SELinux
TARGET_USES_EXT4 := true
TARGET_USES_F2FS := true

# Recovery
BOARD_HAS_NO_REAL_SDCARD := false
BOARD_HAS_NO_SELECT_BUTTON := true
BOARD_RECOVERY_SWIPE := true
BOARD_SUPPRESS_SECURE_ERASE := true
BOARD_CHARGER_DISABLE_INIT := true

# Build
ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_USES_BUILD_COPY_HEADERS := true

# SDK
PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/opensource/interfaces \
    vendor/qcom/opensource/cryptfs_hw

# Crypto
TW_CRYPTO_SYSTEM_VOLD_DEBUG := true

# Strip
TARGET_RELEASETOOLS_EXTENSIONS := device/vivo/PD1936/releasetools

# VNDK
BOARD_VNDK_VERSION := 30
BOARD_VNDK_RUNTIME_DISABLE := false
