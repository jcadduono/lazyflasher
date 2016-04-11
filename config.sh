#!/sbin/sh

## start config variables

tmp=/tmp/boot-editor
# leave boot_block empty for automatic (searches recovery.fstab and other locations)
boot_block=
bin=$tmp/tools
ramdisk=$tmp/ramdisk
ramdisk_patch=$ramdisk-patch
split_img=$tmp/split-img

## end config variables

