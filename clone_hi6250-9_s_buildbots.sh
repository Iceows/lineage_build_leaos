@@ -0,0 +1,39 @@
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
DEVICE_ANNE="iceows/android_device_huawei_anne"
DEVICE_ANNE_PATH="device/huawei/anne"
VENDOR_COMMON="iceows/android_vendor_huawei_hi6250-9-common"
VENDOR_COMMON_PATH="vendor/huawei/hi6250-9-common"
VENDOR_ANNE="iceows/android_vendor_huawei_anne"
VENDOR_ANNE_PATH="vendor/huawei/anne"
KERNEL="iceows/android_kernel_huawei_hi6250-9"
KERNEL_PATH="kernel/huawei/hi6250-9"
HARDWARE="iceows/android_hardware_huawei"
HARDWARE_PATH="hardware/huawei"

# Clone Repos
git clone "$GITHUB""$DEVICE_COMMON" "$DEVICE_COMMON_PATH" -b "$BRANCH"
git clone "$GITHUB""$DEVICE_ANNE" "$DEVICE_ANNE_PATH" -b "$BRANCH"
git clone "$GITHUB""$VENDOR_COMMON" "$VENDOR_COMMON_PATH" -b "$BRANCH"
git clone "$GITHUB""$VENDOR_ANNE" "$VENDOR_ANNE_PATH" -b "$BRANCH"
git clone "$GITHUB""$KERNEL" "$KERNEL_PATH" -b "$BRANCH"
git clone "$GITHUB""$HARDWARE" "$HARDWARE_PATH" -b "$BRANCH"


# That's it!
echo "Successfully cloned all repos"
