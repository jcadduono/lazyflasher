#!/sbin/sh

## start config variables

tmp=/tmp/adb-boot-insecure

# leave boot_block empty for automatic (searches recovery.fstab and other locations)
boot_block=

bin=$tmp/tools
ramdisk=$tmp/ramdisk
ramdisk_patch=$ramdisk-patch
split_img=$tmp/split-img

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
