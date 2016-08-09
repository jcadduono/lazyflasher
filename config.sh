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

case $(uname -m) in
i*86*)
	arch=x86
	;;
x*64*)
	arch=x64
	;;
armv8*)
	arch=arm64
	;;
armv7*)
	arch=armv7
	;;
mips64*)
	arch=mips64
	;;
mips*)
	arch=mips
	;;
*)
	arch=armv7
	;;
esac

bin=$bin/$arch
