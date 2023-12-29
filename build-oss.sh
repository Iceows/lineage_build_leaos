#!/bin/bash
echo ""
echo "LineageOS 20.x - LeaOS-OSS version"
echo ""


echo ""
echo "Setting up build environment"
source build/envsetup.sh
echo ""

echo "Pick patch"
repopick 321337 -f # Deprioritize important developer notifications
repopick 321338 -f # Allow disabling important developer notifications
repopick 321339 -f # Allow disabling USB notifications
repopick 340916 # SystemUI: add burnIn protection
repopick 342860 # codec2: Use numClientBuffers to control the pipeline
repopick 342861 # CCodec: Control the inputs to avoid pipeline overflow
repopick 342862 # [WA] Codec2: queue a empty work to HAL to wake up allocation thread
repopick 342863 # CCodec: Use pipelineRoom only for HW decoder
repopick 342864 # codec2: Change a Info print into Verbose

echo "Unzip blob"
unzip -o ./vendor/huawei/hi6250-9-common/proprietary/vendor/firmware/isp_dts.zip -d ./vendor/huawei/hi6250-9-common/proprietary/vendor/firmware
unzip -o ./vendor/huawei/hi6250-8-common/proprietary/vendor/firmware/isp_dts.zip -d ./vendor/huawei/hi6250-8-common/proprietary/vendor/firmware

echo "Start compile"
brunch anne

echo ""

