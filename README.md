
## Building LineageOS OSS ##

To get started with building LineageOS OSS, you'll need to get familiar with [Git and Repo](https://source.android.com/source/using-repo.html), and set up your environment by referring to [LineageOS Wiki](https://wiki.lineageos.org/devices/redfin/build) (mainly "Install the build packages").

Setup also java jdk 17

   sudo apt-get update && sudo apt-get -y install openjdk-17-jdk 

First, open a new Terminal window, create a new working directory for your LineageOS build (leaos for example) and navigate to it:

    mkdir leaos; cd leaos
    
Initialize your LineageOS workspace:

    repo init -u https://github.com/LOS21-pre-QPR2/android.git -b lineage-21.0 --git-lfs

Clone both this and the patches repos:

    git clone https://github.com/iceows/lineage_build_leaos lineage_build_leaos -b lineage-21.0
    git clone https://github.com/iceows/lineage_patches_leaos lineage_patches_leaos -b lineage-21.0

Be sure to update the cloned repos from time to time!

---

## Building Charlotte (P20 Pro) device LineageOS  ##

    bash lineage_build_leaos/build.sh device charlotte

---

This script is also used to make builds without sync repo. To do so add nosync in the command build line.

    bash lineage_build_leaos/build.sh device nosync charlotte
