# device.mk for iQOO PD1936 (V1936A)

DEVICE_PATH := device/vivo/PD1936

# Product locales
PRODUCT_LOCALES := en_US zh_CN zh_TW

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxxhdpi

# Default properties
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=adb \
    sys.usb.config=adb \
    sys.usb.configfs=1 \
    sys.usb.ffs.ready=1 \
    ro.adb.secure=0 \
    ro.debuggable=1 \
    ro.secure=0 \
    ro.boot.recovery_mode=1 \
    ro.boot.hardware=qcom \
    ro.build.characteristics=nosdcard

# Recovery
PRODUCT_PACKAGES += \
    init.recovery.qcom.rc \
    init.recovery.svc.rc \
    init.recovery.platform.rc \
    init.recovery.touch.rc \
    init.recovery.wifi.rc \
    init.recovery.usb.rc \
    ueventd.qcom.rc \
    recovery.fstab

# Keymaster / Gatekeeper / QSEE decryption chain (FBE)
# Files are placed in prebuilt/ - copied from original recovery.img ramdisk
PRODUCT_PACKAGES += \
    qseecomd \
    android.hardware.keymaster@4.0-service-qti \
    android.hardware.gatekeeper@1.0-service-qti \
    wait_for_keymaster \
    keystore \
    keystore_auth \
    libkeymaster_messages \
    libkeymaster_portable \
    libkeymaster4support \
    libkeymaster4_1support \
    libkeymasterutils \
    libkeymasterdeviceutils \
    libqtikeymaster4 \
    libsoftkeymasterdevice \
    libkeystore_aidl \
    libkeystore_binder \
    libkeystore_parcelables \
    libkeystore-attestation-application-id \
    libvivogatekeeper \
    libwifikeystorehalext \
    vendor.vivo.hardware.wifi.keystore@1.0.so \
    android.hardware.keymaster@3.0 \
    android.hardware.keymaster@4.0 \
    android.hardware.keymaster@4.1 \
    android.system.wifi.keystore@1.0 \
    android.hardware.gatekeeper@1.0 \
    libQSEEComAPI \
    hw_android.hardware.gatekeeper@1.0-impl-qti \
    libkeystore-engine-wifi-hidl \
    libkeystore-wifi-hidl \
    vendor.vivo.hardware.wifi.keystore@1.0

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service \
    android.hardware.usb.gadget@1.0-service

# VNDK
PRODUCT_PACKAGES += \
    vndk-ext \
    libcrypto-v32 \
    libhardware \
    libhardware_legacy \
    libhidlbase \
    libhidltransport \
    libhwbinder \
    libutils \
    libcutils \
    libbase \
    libbinder \
    liblog \
    libselinux \
    libpcre2

# Init
PRODUCT_PACKAGES += \
    init \
    ueventd

# Tools (for adb sideload & shell)
PRODUCT_PACKAGES += \
    sh \
    toybox \
    toolbox \
    recharge \
    watchdogd

# TWRP
PRODUCT_PACKAGES += \
    twrp \
    gsort \
    set_metadata \
    update_engine_sideload \
    care_map_pb \
    ota_metadata \
    plaintext_pb

# Set kernel
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/prebuilt/kernel:kernel

# Copy keymaster binaries & libs to ramdisk
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/prebuilt/vendor/bin/qseecomd:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/qseecomd \
    $(DEVICE_PATH)/prebuilt/vendor/bin/android.hardware.keymaster@4.0-service-qti:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/android.hardware.keymaster@4.0-service-qti \
    $(DEVICE_PATH)/prebuilt/vendor/bin/android.hardware.gatekeeper@1.0-service-qti:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/android.hardware.gatekeeper@1.0-service-qti \
    $(DEVICE_PATH)/prebuilt/system/bin/wait_for_keymaster:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/wait_for_keymaster \
    $(DEVICE_PATH)/prebuilt/system/bin/keystore:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/keystore \
    $(DEVICE_PATH)/prebuilt/system/bin/keystore_auth:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/keystore_auth

# Vendor keymaster libs
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/prebuilt/system/lib64/libkeymaster_messages.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libkeymaster_messages.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/libkeymaster_portable.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libkeymaster_portable.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/libkeymaster4support.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libkeymaster4support.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/libkeymaster4_1support.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libkeymaster4_1support.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/libkeymasterutils.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libkeymasterutils.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/libkeymasterdeviceutils.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libkeymasterdeviceutils.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/libqtikeymaster4.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libqtikeymaster4.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/libsoftkeymasterdevice.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libsoftkeymasterdevice.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/libkeystore_aidl.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libkeystore_aidl.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/libkeystore_binder.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libkeystore_binder.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/libkeystore_parcelables.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libkeystore_parcelables.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/libkeystore-attestation-application-id.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libkeystore-attestation-application-id.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/libvivogatekeeper.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libvivogatekeeper.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/libwifikeystorehalext.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libwifikeystorehalext.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/android.hardware.keymaster@3.0.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.hardware.keymaster@3.0.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/android.hardware.keymaster@4.0.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.hardware.keymaster@4.0.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/android.hardware.keymaster@4.1.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.hardware.keymaster@4.1.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/android.system.wifi.keystore@1.0.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.system.wifi.keystore@1.0.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/android.hardware.gatekeeper@1.0.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.hardware.gatekeeper@1.0.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/vendor.vivo.hardware.wifi.keystore@1.0.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/vendor.vivo.hardware.wifi.keystore@1.0.so

# Vendor libs
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/prebuilt/vendor/lib64/libQSEEComAPI.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libQSEEComAPI.so \
    $(DEVICE_PATH)/prebuilt/vendor/lib64/hw_android.hardware.gatekeeper@1.0-impl-qti.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/hw/android.hardware.gatekeeper@1.0-impl-qti.so \
    $(DEVICE_PATH)/prebuilt/vendor/lib64/libkeystore-engine-wifi-hidl.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libkeystore-engine-wifi-hidl.so \
    $(DEVICE_PATH)/prebuilt/vendor/lib64/libkeystore-wifi-hidl.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libkeystore-wifi-hidl.so \
    $(DEVICE_PATH)/prebuilt/vendor/lib64/vendor.vivo.hardware.wifi.keystore@1.0.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/vendor.vivo.hardware.wifi.keystore@1.0.so

# NOTE: cryptfshw-1-0 (vendor.qti.hardware.cryptfshw@1.0-service-qti) is NOT in
# recovery.img (it's provided by vendor partition in real device). You MUST extract
# it from a stock vendor.img or extract from a running device and copy to:
#   prebuilt/vendor/bin/vendor.qti.hardware.cryptfshw@1.0-service-qti
#   prebuilt/vendor/lib64/libcryptfshw.so (and its dependencies)
# Without cryptfshw, TWRP cannot unwrap the wrapped key for FBE /data.
