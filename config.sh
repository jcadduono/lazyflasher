#!/sbin/sh

## start config variables

tmp=/tmp/samsung-antiroot-removal
bin=$tmp/tools
ramdisk=$tmp/ramdisk
ramdisk_patch=$ramdisk-patch
split_img=$tmp/split-img

## end config variables

arch=arm64
bin=$bin/$arch
