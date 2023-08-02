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
GITLAB="https://gitlab.com/"

# Repos 
DEVICE_COMMON="hisi-oss/android_device_huawei_hi6250-8-common"
DEVICE_COMMON_PATH="device/huawei/hi6250-8-common"
POLICY="hisi-oss/android_device_hisi_sepolicy"
POLICY_PATH="device/hisi/sepolicy"
KERNEL="hisi-oss/android_kernel_huawei_hi6250-8"
KERNEL_PATH="kernel/huawei/hi6250-8"
HARDWARE="hisi-oss/android_hardware_hisi"
HARDWARE_PATH="hardware/hisi"

HARDWAREL="android_hardware_lineage_compat"
HARDWAREL_PATH="hardware/lineage/compat"

# CLANG for Kernel
CLANG="iceows/android_prebuilts_clang_host_linux-x86_clang-r416183b1"
CLANG_PATH="prebuilts/clang/host/linux-x86/clang-r416183b1"

# Huawei Prague repo
DEVICE_PRAGUE="hisi-oss/android_device_huawei_prague"
DEVICE_PRAGUE_PATH="device/huawei/prague"

# EMUI8 common and prague (gitlab)
VENDOR_COMMON_AND_PRAGUE_DEVICES="itsvixano-dev/proprietary_vendor_huawei.git"
VENDOR_HUAWEI_PATH="vendor/huawei"


# Remove all
rm -rf "$DEVICE_COMMON_PATH"
rm -rf "$VENDOR_HUAWEI_PATH"
rm -rf "$KERNEL_PATH"
rm -rf "$HARDWARE_PATH"
rm -rf "$DEVICE_PRAGUE_PATH"
rm -rf "$POLICY_PATH"


# Clone Repos
git clone "$GITHUB""$DEVICE_COMMON" "$DEVICE_COMMON_PATH" -b "staging/$BRANCH"
git clone "$GITHUB""$DEVICE_PRAGUE" "$DEVICE_PRAGUE_PATH" -b "$BRANCH"
git clone "$GITLAB""$VENDOR_COMMON_AND_PRAGUE_DEVICES" "$VENDOR_HUAWEI_PATH" -b "$BRANCH"
git clone "$GITHUB""$KERNEL" "$KERNEL_PATH" -b "$BRANCH"
git clone "$GITHUB""$HARDWARE" "$HARDWARE_PATH" -b "$BRANCH"
git clone "$GITHUB""$POLICY" "$POLICY_PATH" -b "$BRANCH"

git clone "$GITHUB""$CLANG" "$CLANG_PATH"


# That's it!
echo "Successfully cloned all repos"
