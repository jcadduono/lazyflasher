#!/sbin/sh

## start config variables

tmp=/tmp/system-supersu
# leave boot_block empty for automatic (searches recovery.fstab and other locations)
boot_block=
# leave device_names empty to allow flashing on any device
device_names=
bin=$tmp/tools
ramdisk=$tmp/ramdisk
ramdisk_patch=$ramdisk-patch
split_img=$tmp/split-img

## end config variables

case $(uname -m) in
i*86*)
	arch=x86
	libdir=/system/lib
	;;
x*64*)
	arch=x64
	libdir=/system/lib64
	;;
armv8*)
	arch=arm64
	libdir=/system/lib64
	;;
armv7*)
	arch=armv7
	libdir=/system/lib
	;;
mips64*)
	arch=mips64
	libdir=/system/lib64
	;;
mips*)
	arch=mips
	libdir=/system/lib
	;;
*)
	arch=arm
	libdir=/system/lib
	;;
esac

