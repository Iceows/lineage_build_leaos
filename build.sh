#!/bin/bash
echo ""
echo "LineageOS 20.x Unified Buildbot - LeaOS version"
echo "Executing in 5 seconds - CTRL-C to exit"
echo ""
sleep 5

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

# Abort early on error
set -eE
trap '(\
echo;\
echo \!\!\! An error happened during script execution;\
echo \!\!\! Please check console output for bad sync,;\
echo \!\!\! failed patch application, etc.;\
echo\
)' ERR


WITHOUT_CHECK_API=true
WITH_SU=true
START=`date +%s`
BUILD_DATE="$(date +%Y%m%d)"

export OUT_DIR=~/build/LeaOS
export WITH_ADB_INSECURE=true

prep_build() {
    echo "Preparing local manifests"
    mkdir -p .repo/local_manifests

    
    if [ ${MODE} == "device" ]
    then
       cp ./lineage_build_leaos/local_manifests_oss/*.xml .repo/local_manifests
    else
       cp ./lineage_build_leaos/local_manifests_leaos/*.xml .repo/local_manifests
    fi
    
    echo ""
    # repo init -u https://github.com/LineageOS/android.git -b lineage-21.0 --git-lfs  --depth=1
    
    echo "Syncing repos"
    repo sync -c --force-sync --no-clone-bundle --no-tags -j8
    echo ""

    echo "Setting up build environment"
    source build/envsetup.sh &> /dev/null
    mkdir -p ./build-output
    echo ""

    if [ ${MODE} == "device" ]
    then
	echo "no repo pick for device"
    else
    	repopick -t 13-burnin -r -f
    	repopick -t 13-taro-kalama -r -f
   	repopick 321337 -r -f # Deprioritize important developer notifications
  	repopick 321338 -r -f # Allow disabling important developer notifications
 	repopick 321339 -r -f # Allow disabling USB notifications    
    fi
}

apply_patches() {
    echo "Applying patch group ${1}"
    bash ./lineage_build_leaos/apply_patches.sh ./lineage_patches_leaos/${1}
}

prep_device() {

    # EMUI 9
    unzip -o ./vendor/huawei/hi6250-9-common/proprietary/vendor/firmware/isp_dts.zip -d ./vendor/huawei/hi6250-9-common/proprietary/vendor/firmware
    # EMUI 8
    unzip -o ./vendor/huawei/hi6250-8-common/proprietary/vendor/firmware/isp_dts.zip -d ./vendor/huawei/hi6250-8-common/proprietary/vendor/firmware
    :
}

prep_treble() {
    apply_patches patches_treble_prerequisite
    apply_patches patches_treble_td
}

finalize_device() {
    :
}

finalize_treble() {
    rm -f device/*/sepolicy/common/private/genfs_contexts
    cd device/phh/treble
    git clean -fdx
    bash generate.sh lineage
    cd ../../..
}

build_treble_app() {
    cd treble_app
    bash build.sh release
    cp TrebleApp.apk ../vendor/hardware_overlay/TrebleApp/app.apk
    cd ..
    echo
}

build_device() {

      	# croot
      	#TEMPORARY_DISABLE_PATH_RESTRICTIONS=true
      	#export TEMPORARY_DISABLE_PATH_RESTRICTIONS
      	#breakfast ${1} 
      	#mka bootimage 2>&1 | tee make_anne.log 
      	#mka recoveryimage 2>&1
        brunch ${1}
        mv $OUT/lineage-*.zip ./build-output/LeaOS-OSS-20.0-$BUILD_DATE-${1}.zip

}

build_treble() {

    echo "Build Iceows TrebleApp " 
    build_treble_app
    
    echo "Build Lineage LOS20 " 
    case "${1}" in
        ("64VN") TARGET=arm64_bvN;;
        ("64VS") TARGET=arm64_bvS;;
        ("64GN") TARGET=arm64_bgN;;
        (*) echo "Invalid target - exiting"; exit 1;;
    esac
    lunch lineage_${TARGET}-userdebug
    make -j$(nproc --all) installclean
    make -j$(nproc --all) systemimage

    # To sign LOS, just add vendor/extra repo with signed keys in the tree
    # make -j$(nproc --all) target-files-package otatools
    # bash ./lineage_build_leaos/sign.sh "vendor/extra/keys" $OUT/signed-target_files.zip
    # unzip -jqo $OUT/signed-target_files.zip IMAGES/system.img -d $OUT
    mv $OUT/system.img ./build-output/LeaOS-20.0-$BUILD_DATE-${TARGET}.img
}

if ${NOSYNC}
then
    echo "ATTENTION: syncing/patching skipped!"
    echo ""
    echo "Setting up build environment"
    source build/envsetup.sh &> /dev/null
    echo ""
    echo "Build dir : ${OUT_DIR} "
    echo "ADB insecure : ${WITH_ADB_INSECURE} "
    echo

else
    echo "Prep build" 
    prep_build
    prep_${MODE}
 
    if [ ${MODE} == "device" ]
    then
        echo "Applying patches device"
    	apply_patches patches_device
    	apply_patches patches_device_iceows
    else
        echo "Applying patches treble"
    	apply_patches patches_platform
	apply_patches patches_treble
	apply_patches patches_platform_personal
	apply_patches patches_treble_personal
	apply_patches patches_treble_iceows
    fi
    finalize_${MODE}
    echo ""
fi


for var in "${@:2}"
do
    if [ ${var} == "nosync" ]
    then
        continue
    fi
    echo "Starting personal " || echo " build for ${MODE} ${var}"
    build_${MODE} ${var}
done
ls ./build-output | grep 'LeaOS' || true

END=`date +%s`
ELAPSEDM=$(($(($END-$START))/60))
ELAPSEDS=$(($(($END-$START))-$ELAPSEDM*60))
echo "Buildbot completed in $ELAPSEDM minutes and $ELAPSEDS seconds"
echo ""

