# Android.mk - TWRP device tree for iQOO PD1936

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),PD1936)

# ---- Copy init.recovery.*.rc to recovery ramdisk root ----
include $(CLEAR_VARS)
LOCAL_MODULE       := init.recovery.rc
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := recovery/root/init.recovery.rc
LOCAL_MODULE_PATH  := $(TARGET_RECOVERY_ROOT_OUT)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := init.recovery.qcom.rc
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := recovery/root/init.recovery.qcom.rc
LOCAL_MODULE_PATH  := $(TARGET_RECOVERY_ROOT_OUT)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := init.recovery.svc.rc
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := recovery/root/init.recovery.svc.rc
LOCAL_MODULE_PATH  := $(TARGET_RECOVERY_ROOT_OUT)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := init.recovery.platform.rc
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := recovery/root/init.recovery.platform.rc
LOCAL_MODULE_PATH  := $(TARGET_RECOVERY_ROOT_OUT)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := init.recovery.touch.rc
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := recovery/root/init.recovery.touch.rc
LOCAL_MODULE_PATH  := $(TARGET_RECOVERY_ROOT_OUT)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := init.recovery.wifi.rc
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := recovery/root/init.recovery.wifi.rc
LOCAL_MODULE_PATH  := $(TARGET_RECOVERY_ROOT_OUT)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := init.recovery.usb.rc
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := recovery/root/init.recovery.usb.rc
LOCAL_MODULE_PATH  := $(TARGET_RECOVERY_ROOT_OUT)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := ueventd.qcom.rc
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := recovery/root/ueventd.qcom.rc
LOCAL_MODULE_PATH  := $(TARGET_RECOVERY_ROOT_OUT)
include $(BUILD_PREBUILT)

# ---- recovery.fstab ----
include $(CLEAR_VARS)
LOCAL_MODULE       := recovery.fstab
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := recovery.fstab
LOCAL_MODULE_PATH  := $(TARGET_RECOVERY_ROOT_OUT)
include $(BUILD_PREBUILT)

# ---- Prebuilt keymaster binaries -> sbin/ ----
define add-prebuilt-binary
include $(CLEAR_VARS)
LOCAL_MODULE       := $(2)
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_SRC_FILES    := prebuilt/$(1)
LOCAL_MODULE_PATH  := $(TARGET_RECOVERY_ROOT_OUT)/sbin
include $(BUILD_PREBUILT)
endef

# vendor binaries (keymaster/gatekeeper/qseecomd)
$(eval $(call add-prebuilt-binary,vendor/bin/qseecomd,qseecomd))
$(eval $(call add-prebuilt-binary,vendor/bin/android.hardware.keymaster@4.0-service-qti,keymaster-4-0))
$(eval $(call add-prebuilt-binary,vendor/bin/android.hardware.gatekeeper@1.0-service-qti,gatekeeper-1-0))
$(eval $(call add-prebuilt-binary,vendor/bin/vendor.qti.hardware.cryptfshw@1.0-service-qti,cryptfshw-1-0))

# system binaries (keystore)
$(eval $(call add-prebuilt-binary,system/bin/wait_for_keymaster,wait_for_keymaster))
$(eval $(call add-prebuilt-binary,system/bin/keystore,keystore))
$(eval $(call add-prebuilt-binary,system/bin/keystore_auth,keystore_auth))

# ---- Prebuilt libs -> system/lib64/ and vendor/lib64/ ----
define add-prebuilt-lib
include $(CLEAR_VARS)
LOCAL_MODULE       := $(3)
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_SRC_FILES    := prebuilt/$(1)/$(2)
LOCAL_MODULE_PATH  := $(TARGET_RECOVERY_ROOT_OUT)/$(1)
include $(BUILD_PREBUILT)
endef

# system/lib64
SYSTEM_LIBS := \
    libkeymaster_messages.so \
    libkeymaster_portable.so \
    libkeymaster4support.so \
    libkeymaster4_1support.so \
    libkeymasterutils.so \
    libkeymasterdeviceutils.so \
    libqtikeymaster4.so \
    libsoftkeymasterdevice.so \
    libkeystore_aidl.so \
    libkeystore_binder.so \
    libkeystore_parcelables.so \
    libkeystore-attestation-application-id.so \
    libvivogatekeeper.so \
    libwifikeystorehalext.so \
    android.hardware.gatekeeper@1.0.so \
    android.hardware.keymaster@3.0.so \
    android.hardware.keymaster@4.0.so \
    android.hardware.keymaster@4.1.so \
    android.system.wifi.keystore@1.0.so \
    vendor.vivo.hardware.wifi.keystore@1.0.so

$(foreach lib,$(SYSTEM_LIBS),$(eval $(call add-prebuilt-lib,system/lib64,$(lib),$(basename $(lib)))))

# vendor/lib64
VENDOR_LIBS := \
    libQSEEComAPI.so \
    libcryptfshw.so \
    libkeystore-engine-wifi-hidl.so \
    libkeystore-wifi-hidl.so \
    vendor.vivo.hardware.wifi.keystore@1.0.so

$(foreach lib,$(VENDOR_LIBS),$(eval $(call add-prebuilt-lib,vendor/lib64,$(lib),$(basename $(lib)))))

# vendor/lib64/hw
HW_LIBS := \
    android.hardware.gatekeeper@1.0-impl-qti.so

$(foreach lib,$(HW_LIBS),$(eval $(call add-prebuilt-lib,vendor/lib64/hw,$(lib),$(basename $(lib)))))

# ---- Copy kernel ----
include $(CLEAR_VARS)
LOCAL_MODULE       := kernel
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_SRC_FILES    := prebuilt/kernel
LOCAL_MODULE_PATH  := $(PRODUCT_OUT)
include $(BUILD_PREBUILT)

endif
