
## Building PHH-based LineageOS GSIs ##

To get started with building LineageOS GSI, you'll need to get familiar with [Git and Repo](https://source.android.com/source/using-repo.html), and set up your environment by referring to [LineageOS Wiki](https://wiki.lineageos.org/devices/redfin/build) (mainly "Install the build packages") and [How to build a GSI](https://github.com/phhusson/treble_experimentations/wiki/How-to-build-a-GSI%3F).


First, open a new Terminal window, create a new working directory for your LineageOS build (leaos for example) and navigate to it:

    mkdir leaos; cd leaos
    
Clone the modified treble_experimentations repo there:

    git clone https://github.com/iceows/treble_experimentations

Initialize your LineageOS workspace:

    repo init -u https://github.com/LineageOS/android.git -b lineage-19.1

Clone both this and the patches repos:

    git clone https://github.com/iceows/lineage_build_leaos lineage_build_leaos -b lineage-19.1
    git clone https://github.com/iceows/lineage_patches_leaos lineage_patches_leaos -b lineage-19.1


Finally, start the build script (Dynamic root):

    bash lineage_build_leaos/build.sh treble 64BVZ


Be sure to update the cloned repos from time to time!

---

A-only targets for Huawei hi6250 re generated from AB images instead of source-built - refer to [huawei-creator](https://github.com/iceows/huawei-creator).

	sudo ./run-huawei-aonly.sh "myimage.img"  "LeaOS" "PRA-LX1"

---

This script is also used to make builds without sync repo. To do so add nosync in the command build line.

    bash lineage_build_leaos/build.sh treble nosync 64BZ


## Building LineageOS for device huawei ##

First, open a new Terminal window, create a new working directory for your LineageOS build (leaos for example) and navigate to it:

    mkdir leaos; cd leaos
    
Initialize your LineageOS workspace:

    repo init -u https://github.com/LineageOS/android.git -b lineage-19.1

Clone both this and the patches repos:

    git clone https://github.com/iceows/lineage_build_leaos lineage_build_leaos -b lineage-19.1
    git clone https://github.com/iceows/lineage_patches_leaos lineage_patches_leaos -b lineage-19.1
    
Clone huawei device repos (vendor, kernel, etc..) for your phone device

    bash lineage_build_leaos/clone_hi6250-9_s_buildbots.sh
    
Finally, start the build script for device (example : anne) :

    bash lineage_build_leaos/build.sh device anne

    
