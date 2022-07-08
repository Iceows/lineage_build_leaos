#!/bin/bash
echo ""
echo "LineageOS 18.x Unified Buildbot - LeaOS version"
echo "Executing in 5 seconds - CTRL-C to exit"
echo ""
sleep 5

if [ $# -lt 1 ]
then
    echo "Not enough arguments - exiting"
    echo ""
    exit 1
fi

MODE=${1}
NOSYNC=false
PERSONAL=false
ICEOWS=true
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

START=`date +%s`
BUILD_DATE="$(date +%Y%m%d)"
WITHOUT_CHECK_API=true
WITH_SU=true

repo init -u https://github.com/LineageOS/android.git -b lineage-18.1

prep_build() {
    echo "Preparing local manifests"
    mkdir -p .repo/local_manifests
    cp ./lineage_build_leaos/local_manifests_leaos/*.xml .repo/local_manifests
    echo ""

    echo "Syncing repos"
    repo sync -c --force-sync --no-clone-bundle --no-tags -j$(nproc --all)
    echo ""

    echo "Setting up build environment"
    source build/envsetup.sh &> /dev/null
    mkdir -p ~/build-output
    echo ""

    repopick -Q "(status:open+AND+NOT+is:wip)+(label:Code-Review>=0+AND+label:Verified>=0)+project:LineageOS/android_packages_apps_Trebuchet+branch:lineage-19.1+NOT+332083"
    repopick -t twelve-burnin
    repopick -t qs-lightmode
    repopick -t powermenu-lightmode
    repopick 321337 # Deprioritize important developer notifications
    repopick 321338 # Allow disabling important developer notifications
    repopick 321339 # Allow disabling USB notifications
    repopick 329229 -f # Alter model name to avoid SafetyNet HW attestation enforcement
    repopick 329230 -f # keystore: Block key attestation for SafetyNet
    repopick 329409 # SystemUI: screenshot: open the screenshot instead of edit
    repopick 331534 -f # SystemUI: Add support to add/remove QS tiles with one tap
    repopick 331791 # Skip checking SystemUI's permission for observing sensor privacy
}

apply_patches() {
    echo "Applying patch group ${1}"
    bash ./treble_experimentations/apply-patches.sh ./lineage_patches_leaos/${1}
}

prep_device() {
    :
}

prep_treble() {
    echo "Applying patch treble prerequisite and phh"
    apply_patches patches_treble_prerequisite
    apply_patches patches_treble_phh

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

build_device() {
    if [ ${1} == "arm64" ]
    then
        lunch lineage_arm64-userdebug
        make -j$(nproc --all) systemimage
        mv $OUT/system.img ~/build-output/lineage-18.1-$BUILD_DATE-UNOFFICIAL-arm64$(${PERSONAL} && echo "-personal" || echo "").img
    else
        brunch ${1}
        mv $OUT/lineage-*.zip ~/build-output/lineage-18.1-$BUILD_DATE-UNOFFICIAL-${1}$($PERSONAL && echo "-personal" || echo "").zip
    fi
}

build_treble() {
    case "${1}" in
        ("64BVS") TARGET=treble_arm64_bvS;;
        ("64BVZ") TARGET=treble_arm64_bvZ;;
        ("64BVN") TARGET=treble_arm64_bvN;;
        (*) echo "Invalid target - exiting"; exit 1;;
    esac
    lunch ${TARGET}-userdebug
    make installclean
    make -j$(nproc --all) systemimage
    make vndk-test-sepolicy
    mv $OUT/system.img ~/build-output/LeaOS-$BUILD_DATE-${TARGET}.img
}

if ${NOSYNC}
then
    echo "ATTENTION: syncing/patching skipped!"
    echo ""
    echo "Setting up build environment"
    source build/envsetup.sh &> /dev/null
    echo ""
else
    prep_build
    echo "Applying patches"
    prep_treble
    apply_patches patches_platform
    apply_patches patches_treble
    apply_patches patches_platform_personal
    apply_patches patches_treble_personal
    finalize_treble
    echo ""
fi

for var in "${@:2}"
do
    if [ ${var} == "nosync" ]
    then
        continue
    fi
    echo "Starting $(${PERSONAL} && echo "personal " || echo "")build for ${MODE} ${var}"
    build_${MODE} ${var}
done
ls ~/build-output | grep 'LeaOS' || true

END=`date +%s`
ELAPSEDM=$(($(($END-$START))/60))
ELAPSEDS=$(($(($END-$START))-$ELAPSEDM*60))
echo "Buildbot completed in $ELAPSEDM minutes and $ELAPSEDS seconds"
echo ""
