#!/sbin/sh

## start config variables

tmp=/tmp/note7-disable-charging-limit
bin=$tmp/tools
split_img=$tmp/split-img
boot_block=/dev/block/bootdevice/by-name/BOOT

## end config variables

arch=arm64
bin=$bin/$arch
