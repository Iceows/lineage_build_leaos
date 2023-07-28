#!/bin/bash

#
# This Script is by Iceows
#

#
#

# Config
BRANCH="lineage-20"
LOCAL_PATH="."
GITHUB="https://github.com/"


# Repos
DEVICE_COMMON="hisi-oss/android_device_huawei_hi6250-8-common"
DEVICE_COMMON_PATH="device/huawei/hi6250-8-common"
VENDOR_COMMON="hisi-oss/proprietary_vendor_huawei_hi6250-8-common"
VENDOR_COMMON_PATH="vendor/huawei/hi6250-8-common"
KERNEL="hisi-oss/android_kernel_huawei_hi6250-8"
KERNEL_PATH="kernel/huawei/hi6250-8"
HARDWARE="hisi-oss/android_hardware_hisi"
HARDWARE_PATH="hardware/hisi"

CLANG="iceows/android_prebuilts_clang_host_linux-x86_clang-r416183b1"
CLANG_PATH="prebuilts/clang/host/linux-x86/clang-r416183b1"

# Huawei warsaw repo
DEVICE_WARSAW="hisi-oss/android_device_huawei_warsaw"
DEVICE_WARSAW_PATH="device/huawei/warsaw"
VENDOR_WARSAW="hisi-oss/proprietary_vendor_huawei_warsaw"
VENDOR_WARSAW_PATH="vendor/huawei/warsaw"


# Remove all
rm -rf "$DEVICE_COMMON_PATH"
rm -rf "$VENDOR_COMMON_PATH" 
rm -rf "$KERNEL_PATH"
rm -rf "$HARDWARE_PATH"
rm -rf "$DEVICE_WARSAW_PATH"
rm -rf "$VENDOR_WARSAW_PATH"



# Clone Repos
git clone "$GITHUB""$DEVICE_COMMON" "$DEVICE_COMMON_PATH" -b "$BRANCH"
git clone "$GITHUB""$DEVICE_WARSAW" "$DEVICE_WARSAW_PATH" -b "$BRANCH"
git clone "$GITHUB""$VENDOR_COMMON" "$VENDOR_COMMON_PATH"
git clone "$GITHUB""$VENDOR_WARSAW" "$VENDOR_WARSAW_PATH" -b "$BRANCH"
git clone "$GITHUB""$KERNEL" "$KERNEL_PATH" -b "$BRANCH"
git clone "$GITHUB""$HARDWARE" "$HARDWARE_PATH" -b "$BRANCH"

git clone "$GITHUB""$CLANG" "$CLANG_PATH"


# That's it!
echo "Successfully cloned all repos"
