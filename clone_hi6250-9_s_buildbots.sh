#!/bin/bash

#
# This Script is by Iceows
#

#
#

# Config
BRANCH="lineage-20.0"
LOCAL_PATH="."
GITHUB="https://github.com/"


# Repos
DEVICE_COMMON="iceows/android_device_huawei_hi6250-9-common"
DEVICE_COMMON_PATH="device/huawei/hi6250-9-common"
VENDOR_COMMON="iceows/android_vendor_huawei_hi6250-9-common"
VENDOR_COMMON_PATH="vendor/huawei/hi6250-9-common"
KERNEL="iceows/android_kernel_huawei_hi6250-9"
KERNEL_PATH="kernel/huawei/hi6250-9"
HARDWARE="iceows/android_hardware_huawei"
HARDWARE_PATH="hardware/huawei"

CLANG="iceows/android_prebuilts_clang_host_linux-x86_clang-r416183b1"
CLANG_PATH="prebuilts/clang/host/linux-x86/clang-r416183b1"

# Huawei Anne repo
DEVICE_ANNE="iceows/android_device_huawei_anne"
DEVICE_ANNE_PATH="device/huawei/anne"
VENDOR_ANNE="iceows/android_vendor_huawei_anne"
VENDOR_ANNE_PATH="vendor/huawei/anne"

# Huawei Bond repo
DEVICE_BOND="wudilsr-OpenSource/android_device_huawei_bond"
DEVICE_BOND_PATH="device/huawei/bond"
VENDOR_BOND="wudilsr-OpenSource/android_vendor_huawei_bond"
VENDOR_BOND_PATH="vendor/huawei/bond"

# Remove all
rm -rf "$DEVICE_COMMON_PATH"
rm -rf "$VENDOR_COMMON_PATH" 
rm -rf "$KERNEL_PATH"
rm -rf "$HARDWARE_PATH"
rm -rf "$DEVICE_ANNE_PATH"
rm -rf "$VENDOR_ANNE_PATH"
rm -rf "$DEVICE_BOND_PATH"
rm -rf "$VENDOR_BOND_PATH"


# Clone Repos
git clone "$GITHUB""$DEVICE_COMMON" "$DEVICE_COMMON_PATH" -b "$BRANCH"
git clone "$GITHUB""$DEVICE_ANNE" "$DEVICE_ANNE_PATH" -b "$BRANCH"
git clone "$GITHUB""$VENDOR_COMMON" "$VENDOR_COMMON_PATH" -b "$BRANCH"
git clone "$GITHUB""$VENDOR_ANNE" "$VENDOR_ANNE_PATH" -b "$BRANCH"
git clone "$GITHUB""$KERNEL" "$KERNEL_PATH" -b "$BRANCH"
git clone "$GITHUB""$HARDWARE" "$HARDWARE_PATH" -b "$BRANCH"

git clone "$GITHUB""$CLANG" "$CLANG_PATH"


# That's it!
echo "Successfully cloned all repos"
