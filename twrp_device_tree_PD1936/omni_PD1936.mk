# TWRP device tree for iQOO PD1936 (V1936A)
# Platform: Qualcomm SM8150 / msmnile
# Android 11 / Kernel 4.14.190-perf

# Inherit from omni common
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/embedded.mk)

# TWRP
$(call inherit-product, vendor/omni/config/common.mk)

# Device
PRODUCT_NAME := omni_PD1936
PRODUCT_DEVICE := PD1936
PRODUCT_BRAND := vivo
PRODUCT_MODEL := V1936A
PRODUCT_MANUFACTURER := vivo
PRODUCT_RELEASE_NAME := PD1936

# AAPT
PRODUCT_AAPT_CONFIG := large
PRODUCT_AAPT_PREF_CONFIG := xxxhdpi
PRODUCT_CHARACTERISTICS := nosdcard

# Use TWRP as recovery
PRODUCT_PACKAGES += \
    init.recovery.qcom.rc \
    init.recovery.svc.rc \
    init.recovery.platform.rc \
    init.recovery.touch.rc \
    init.recovery.wifi.rc \
    init.recovery.usb.rc \
    ueventd.qcom.rc \
    recovery.fstab

# Boot animation / screen
TW_SCREEN_BLANK_ON_BOOT := true
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888

# Recovery
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.adb.secure=0 \
    ro.debuggable=1 \
    ro.secure=0 \
    sys.usb.configfs=1 \
    sys.usb.config=adb

# Recovery properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.twrp.boot=1 \
    ro.boot.recovery_mode=1

# TWRP permissions (allow su)
PRODUCT_PACKAGES += \
    toolbox \
    sh \
    toybox
