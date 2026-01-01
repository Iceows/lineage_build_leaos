#!/bin/bash
echo ""
echo "LineageOS 21.x Unified Buildbot - LeaOS version"
echo "Executing in 5 seconds - CTRL-C to exit"
echo "You must init repo with this cmd"
echo "repo init -u https://github.com/LOS21-pre-QPR2/android.git -b lineage-21.0 --git-lfs"
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
    
    echo "Syncing repos"
    repo sync -c --force-sync --no-clone-bundle --no-tags -j$(nproc --all)
    echo ""

    echo "Setting up build environment"
    source build/envsetup.sh &> /dev/null
    mkdir -p ./build-output
    echo ""

    if [ ${MODE} == "device" ]
    then
	echo "no repo pick for device"
    else
        # Make picks here only if the target repo uses its original remote
	echo "no repo pick for treble"
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
    cd vendor/hardware_overlay
    git add TrebleApp/app.apk
    git commit -m "[TEMP] Up TrebleApp to $BUILD_DATE"
    cd ../..
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
        mv $OUT/lineage-*.zip ./build-output/LeaOS-OSS-21.0-$BUILD_DATE-${1}.zip

}

build_treble() {

   
    echo "Build Lineage LOS21 " 
    case "${1}" in
        ("64VN") TARGET=arm64_bvN;;
        ("64VS") TARGET=arm64_bvS;;
        ("64GN") TARGET=arm64_bgN;;
        ("64GS") TARGET=arm64_bgS;;
        ("64ON") TARGET=arm64_boN;;
        ("64OS") TARGET=arm64_boS;;
        ("64YN") TARGET=arm64_byN;;
        ("64YS") TARGET=arm64_byS;;
        ("64EN") TARGET=arm64_beN;;
        ("64ES") TARGET=arm64_beS;;
        (*) echo "Invalid target - exiting"; exit 1;;
    esac
    lunch lineage_${TARGET}-userdebug
    make -j$(nproc --all) installclean
    make -j$(nproc --all) systemimage

    # To sign LOS, just add vendor/extra repo with signed keys in the tree
    # make -j$(nproc --all) target-files-package otatools
    # bash ./lineage_build_leaos/sign.sh "vendor/extra/keys" $OUT/signed-target_files.zip
    # unzip -jqo $OUT/signed-target_files.zip IMAGES/system.img -d $OUT
    mv $OUT/system.img ./build-output/LeaOS-21.0-$BUILD_DATE-${TARGET}.img
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
    	apply_patches patches_${MODE}
    	apply_patches patches_${MODE}_iceows
    else
        echo "Applying patches treble"
    	apply_patches patches_platform
	apply_patches patches_${MODE}
	apply_patches patches_platform_personal
	apply_patches patches_${MODE}_personal
	apply_patches patches_${MODE}_iceows
    fi
    finalize_${MODE}
    echo ""
    
    echo "Build Iceows TrebleApp " 
    build_treble_app
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

