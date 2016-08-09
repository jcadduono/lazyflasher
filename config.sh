#!/sbin/sh

## start config variables

tmp=/tmp/recovery-editor
# leave boot_block empty for automatic (searches recovery.fstab and other locations)
recovery_block=
bin=$tmp/tools
ramdisk=$tmp/ramdisk
ramdisk_patch=$ramdisk-patch
split_img=$tmp/split-img

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
