#!/sbin/sh

## start config variables

tmp=/tmp/system-supersu
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
	libdir=/system/lib
	;;
x86_64)
	arch=x64
	libdir=/system/lib64
	;;
arm64*)
	arch=arm64
	libdir=/system/lib64
	;;
armeabi*)
	arch=armv7
	libdir=/system/lib
	;;
mips64)
	arch=mips64
	libdir=/system/lib64
	;;
mips)
	arch=mips
	libdir=/system/lib
	;;
*)
	arch=armv7
	libdir=/system/lib
	;;
esac

bin=$bin/$arch
