#!/bin/bash

#
# This Script is by A2L5E0X1 and ICEOWS
#

#
#

# Config
BRANCH="lineage-18.1"
LOCAL_PATH="."
#GITHUB="git@github.com:"
GITHUB="https://github.com/"
#GITLAB="git@gitlab.com:"
GITLAB="https://gitlab.com/"

# Repos
DEVICE_COMMON="hi6250-oss/android_device_huawei_hi6250-8-common"
DEVICE_COMMON_PATH="device/huawei/hi6250-8-common"
DEVICE_PRA="hi6250-oss/android_device_huawei_prague"
DEVICE_PRA_PATH="device/huawei/prague"
VENDOR_COMMON="A2L5E0X1/android_vendor_huawei_hi6250-8-common"
VENDOR_COMMON_PATH="vendor/huawei/hi6250-8-common"
VENDOR_PRA="hi6250-oss/android_vendor_huawei_prague"
VENDOR_PRA_PATH="vendor/huawei/prague"
KERNEL="hi6250-oss/android_kernel_huawei_hi6250-8"
KERNEL_PATH="kernel/huawei/hi6250-8"
HARDWARE="hi6250-oss/android_hardware_huawei"
HARDWARE_PATH="hardware/huawei"

# Clone Repos

git clone "$GITHUB""$DEVICE_PRA" "$DEVICE_PRA_PATH" -b "$BRANCH"
git clone "$GITLAB""$VENDOR_COMMON" "$VENDOR_COMMON_PATH" -b "$BRANCH"
git clone "$GITHUB""$VENDOR_PRA" "$VENDOR_PRA_PATH" -b "$BRANCH"
git clone "$GITHUB""$KERNEL" "$KERNEL_PATH" -b "$BRANCH"
git clone "$GITHUB""$HARDWARE" "$HARDWARE_PATH" -b "$BRANCH"


# That's it!
echo "Successfully cloned all repos"
