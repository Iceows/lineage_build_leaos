
## Building PHH-based LineageOS GSIs ##

To get started with building LineageOS GSI, you'll need to get familiar with [Git and Repo](https://source.android.com/source/using-repo.html) as well as [How to build a GSI](https://github.com/phhusson/treble_experimentations/wiki/How-to-build-a-GSI%3F).

First, open a new Terminal window, which defaults to your home directory.  

Create a new working directory for your LineageOS build and navigate to it:

    mkdir lineage-16.x-build-gsi; cd lineage-16.x-build-gsi

Initialize your LineageOS workspace:

    repo init -u https://github.com/LineageOS/android.git -b lineage-16.0

Clone the modified treble patches and this repo:

    git clone https://github.com/iceows/lineage_patches_leaos lineage_patches_leaos -b lineage-16.0
    git clone https://github.com/iceows/lineage_build_leaos lineage_build_leaos -b lineage-16.0

Finally, start the build script:

    bash lineage_build_leaos/buildbot_treble.sh

Be sure to update the cloned repos from time to time!
