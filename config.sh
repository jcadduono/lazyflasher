#!/sbin/sh

## start config variables

tmp=/tmp/kernel-flasher

# leave device_names empty to allow flashing on any device
device_names=
# leave boot_block empty for automatic (searches recovery.fstab and other locations)
boot_block=
# set this to /system/lib64 on a 64-bit device
lib_dir=/system/lib

bin=$tmp/tools
ramdisk=$tmp/ramdisk
ramdisk_patch=$ramdisk-patch
split_img=$tmp/split-img
modules=$tmp/modules

## end config variables

