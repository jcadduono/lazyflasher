#!/sbin/sh

## start config variables

tmp=/tmp/twrp-data-fstype-swap
bin=$tmp/tools
ramdisk=$tmp/ramdisk
split_img=$tmp/split-img
# set this only if boot-patcher.sh can't find your recovery partition
boot_block=

## end config variables

case $(getprop ro.product.cpu.abi) in
x86)
	arch=x86
	;;
x86_64)
	arch=x64
	;;
arm64*)
	arch=arm64
	;;
armeabi*)
	arch=armv7
	;;
mips64)
	arch=mips64
	;;
mips)
	arch=mips
	;;
*)
	arch=armv7
	;;
esac

bin=$bin/$arch
