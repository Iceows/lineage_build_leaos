#!/bin/bash
echo ""
echo "LineageOS 20.x - LeaOS-OSS version"
echo ""

if [ $# -lt 1 ]
then
    echo "Not enough arguments - exiting"
    echo ""
    exit 1
fi


PERSONAL=false
ICEOWS=true

MODE=${1}
if [ ${MODE} != "device" ] && [ ${MODE} != "treble" ]
then
    echo "Invalid mode - exiting"
    echo ""
    exit 1
fi

NOSYNC=false
for var in "${@:2}"
do
    if [ ${var} == "nosync" ]
    then
        NOSYNC=true
    fi
done


echo "Building with NoSync : $NOSYNC - Mode : ${MODE}"

echo "Syncing repos"
repo sync -c --force-sync --no-clone-bundle --no-tags -j$(nproc --all)
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

echo "Apply Iceows patches for Huawei device"
bash ./apply_patches.sh ./lineage_patches_leaos/patches_device
bash ./apply_patches.sh ./lineage_patches_leaos/patches_device_iceows


    	
echo "Start compile"
for var in "${@:2}"
do
    if [ ${var} == "nosync" ]
    then
        continue
    fi
    echo "Starting " || echo " build for ${MODE} ${var}"
    brunch ${var}
done

echo ""

