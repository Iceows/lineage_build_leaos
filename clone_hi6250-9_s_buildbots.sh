#!/bin/bash

#
# This Script is by A2L5E0X1
#

#
# NOTE: currently figo doesn't have a lineage-19.1 branch!
#

# Config
BRANCH="lineage-19.1"
LOCAL_PATH="."
#GITHUB="git@github.com:"
GITHUB="https://github.com/"
#GITLAB="git@gitlab.com:"
GITLAB="https://gitlab.com/"

# Repos
DEVICE_COMMON="hi6250-oss-old/android_device_huawei_hi6250-9-common"
DEVICE_COMMON_PATH="device/huawei/hi6250-9-common"
#DEVICE_FIGO="hi6250-oss/android_device_huawei_figo"
#DEVICE_FIGO_PATH="device/huawei/figo"
DEVICE_ANNE="hi6250-oss-old/android_device_huawei_anne"
DEVICE_ANNE_PATH="device/huawei/anne"
DEVICE_BOND="hi6250-oss-old/android_device_huawei_bond"
DEVICE_BOND_PATH="device/huawei/bond"
VENDOR_COMMON="A2L5E0X1/android_vendor_huawei_hi6250-9-common"
VENDOR_COMMON_PATH="vendor/huawei/hi6250-9-common"
#VENDOR_FIGO="hi6250-oss/android_vendor_huawei_figo"
#VENDOR_FIGO_PATH="vendor/huawei/figo"
VENDOR_ANNE="hi6250-oss-old/android_vendor_huawei_anne"
VENDOR_ANNE_PATH="vendor/huawei/anne"
VENDOR_BOND="hi6250-oss-old/android_vendor_huawei_bond"
VENDOR_BOND_PATH="vendor/huawei/bond"
KERNEL="hi6250-oss-old/android_kernel_huawei_hi6250-9"
KERNEL_PATH="kernel/huawei/hi6250-9"
HARDWARE="hi6250-oss-old/android_hardware_huawei"
HARDWARE_PATH="hardware/huawei"

# Clone Repos
git clone "$GITHUB""$DEVICE_COMMON" "$DEVICE_COMMON_PATH" -b "$BRANCH"
#git clone "$GITHUB""$DEVICE_FIGO" "$DEVICE_FIGO_PATH" -b "$BRANCH"
git clone "$GITHUB""$DEVICE_ANNE" "$DEVICE_ANNE_PATH" -b "$BRANCH"
git clone "$GITHUB""$DEVICE_BOND" "$DEVICE_BOND_PATH" -b "$BRANCH"
git clone "$GITLAB""$VENDOR_COMMON" "$VENDOR_COMMON_PATH" -b "$BRANCH"
#git clone "$GITHUB""$VENDOR_FIGO" "$VENDOR_FIGO_PATH" -b "$BRANCH"
git clone "$GITHUB""$VENDOR_ANNE" "$VENDOR_ANNE_PATH" -b "$BRANCH"
git clone "$GITHUB""$VENDOR_BOND" "$VENDOR_BOND_PATH" -b "$BRANCH"
git clone "$GITHUB""$KERNEL" "$KERNEL_PATH" -b "$BRANCH"
git clone "$GITHUB""$HARDWARE" "$HARDWARE_PATH" -b "$BRANCH"

# Symlink hooks to get Change-id
for REPOS in "$DEVICE_COMMON_PATH" "$DEVICE_FIGO_PATH" "$DEVICE_ANNE_PATH" "$DEVICE_BOND_PATH" "$VENDOR_COMMON_PATH" "$VENDOR_FIGO_PATH" "$VENDOR_ANNE_PATH" "$VENDOR_BOND_PATH" "$KERNEL_PATH"; do rm -rf "$REPOS"/.git/hooks; ln -s ../../../../.repo/repo/hooks "$REPOS"/.git/hooks; done
for REPOS in "$HARDWARE_PATH"; do rm -rf "$REPOS"/.git/hooks; ln -s ../../../.repo/repo/hooks "$REPOS"/.git/hooks; done

# That's it!
echo "Successfully cloned all repos"
