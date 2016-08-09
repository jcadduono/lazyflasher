#!/sbin/sh

## start config variables

tmp=/tmp/no-verity-opt-encrypt
bin=$tmp/tools
ramdisk=$tmp/ramdisk
ramdisk_patch=$ramdisk-patch
split_img=$tmp/split-img
# set this only if boot-patcher.sh can't find your boot partition
boot_block=

## end config variables

