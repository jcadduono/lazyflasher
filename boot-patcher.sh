#!/sbin/sh
# LazyFlasher boot image patcher script by jcadduono

tmp=/tmp/note7-disable-charging-limit

console=$(cat /tmp/console)
[ "$console" ] || console=/proc/$$/fd/1

cd "$tmp"
. config.sh

chmod -R 755 "$bin"
rm -rf "$ramdisk" "$split_img"
mkdir "$ramdisk" "$split_img"

print() {
	[ "$1" ] && {
		echo "ui_print - $1" > $console
	} || {
		echo "ui_print  " > $console
	}
	echo
}

abort() {
	[ "$1" ] && {
		print "Error: $1!"
		print "Aborting..."
	}
	exit 1
}

## start install methods

# find the location of the boot block
find_boot() {
	verify_block() {
		boot_block=$(readlink -f "$boot_block")
		# if the boot block is a file, we must use dd
		if [ -f "$boot_block" ]; then
			use_dd=true
		# if the boot block is a block device, we use flash_image when possible
		elif [ -b "$boot_block" ]; then
			case "$boot_block" in
				/dev/block/bml*|/dev/block/mtd*|/dev/block/mmc*)
					use_dd=false ;;
				*)
					use_dd=true ;;
			esac
		# otherwise we have to keep trying other locations
		else
			return 1
		fi
		print "Found boot partition at: $boot_block"
	}
	# if we already have boot block set then verify and use it
	[ "$boot_block" ] && verify_block && return
	# otherwise, time to go hunting!
	[ -f /etc/recovery.fstab ] && {
		# recovery fstab v1
		boot_block=$(awk '$1 == "/boot" {print $3}' /etc/recovery.fstab)
		[ "$boot_block" ] && verify_block && return
		# recovery fstab v2
		boot_block=$(awk '$2 == "/boot" {print $1}' /etc/recovery.fstab)
		[ "$boot_block" ] && verify_block && return
		return 1
	} && return
	[ -f /fstab.qcom ] && {
		# qcom fstab
		boot_block=$(awk '$2 == "/boot" {print $1}' /fstab.qcom)
		[ "$boot_block" ] && verify_block && return
		return 1
	} && return
	[ -f /proc/emmc ] && {
		# emmc layout
		boot_block=$(awk '$4 == "\"boot\"" {print $1}' /proc/emmc)
		[ "$boot_block" ] && boot_block=/dev/block/$(echo "$boot_block" | cut -f1 -d:) && verify_block && return
		return 1
	} && return
	[ -f /proc/mtd ] && {
		# mtd layout
		boot_block=$(awk '$4 == "\"boot\"" {print $1}' /proc/mtd)
		[ "$boot_block" ] && boot_block=/dev/block/$(echo "$boot_block" | cut -f1 -d:) && verify_block && return
		return 1
	} && return
	[ -f /proc/dumchar_info ] && {
		# mtk layout
		boot_block=$(awk '$1 == "/boot" {print $5}' /proc/dumchar_info)
		[ "$boot_block" ] && verify_block && return
		return 1
	} && return
	abort "Unable to find boot block location"
}

# dump boot and unpack the android boot image
dump_boot() {
	print "Dumping & unpacking original boot image..."
	if $use_dd; then
		dd if="$boot_block" of="$tmp/boot.img"
	else
		dump_image "$boot_block" "$tmp/boot.img"
	fi
	[ $? = 0 ] || abort "Unable to read boot partition"
	"$bin/unpackbootimg" -i "$tmp/boot.img" -o "$split_img" || {
		abort "Unpacking boot image failed"
	}
}

# build the new boot image
build_boot() {
	cd "$split_img"
	kernel=
	for image in zImage zImage-dtb Image Image-dtb Image.gz Image.gz-dtb; do
		if [ -s $tmp/$image ]; then
			kernel="$tmp/$image"
			print "Found replacement kernel $image!"
			break
		fi
	done
	[ "$kernel" ] || kernel="$(ls ./*-kernel)"
	if [ -s $tmp/ramdisk-new ]; then
		rd="$tmp/ramdisk-new"
		print "Found replacement ramdisk image!"
	else
		rd="$(ls ./*-ramdisk)"
	fi
	if [ -s $tmp/dtb.img ]; then
		dtb="$tmp/dtb.img"
		print "Found replacement device tree image!"
	else
		dtb="$(ls ./*-dt)"
	fi
	"$bin/mkbootimg" \
		--kernel "$kernel" \
		--ramdisk "$rd" \
		--dt "$dtb" \
		--second "$(ls ./*-second)" \
		--cmdline "$(cat ./*-cmdline)" \
		--board "$(cat ./*-board)" \
		--base "$(cat ./*-base)" \
		--pagesize "$(cat ./*-pagesize)" \
		--kernel_offset "$(cat ./*-kernel_offset)" \
		--ramdisk_offset "$(cat ./*-ramdisk_offset)" \
		--second_offset "$(cat ./*-second_offset)" \
		--tags_offset "$(cat ./*-tags_offset)" \
		-o $tmp/boot-new.img || {
			abort "Repacking boot image failed"
		}
}

# append Samsung enforcing tag to prevent warning at boot
samsung_tag() {
	if getprop ro.product.manufacturer | grep -iq '^samsung$'; then
		echo "SEANDROIDENFORCE" >> "$tmp/boot-new.img"
	fi
}

# verify that the boot image exists and can fit the partition
verify_size() {
	print "Verifying boot image size..."
	cd "$tmp"
	[ -s boot-new.img ] || abort "New boot image not found!"
	old_sz=$(wc -c < boot.img)
	new_sz=$(wc -c < boot-new.img)
	if [ "$new_sz" -gt "$old_sz" ]; then
		size_diff=$((new_sz - old_sz))
		print " Partition size: $old_sz bytes"
		print "Boot image size: $new_sz bytes"
		abort "Boot image is $size_diff bytes too large for partition"
	fi
}

# write the new boot image to boot block
write_boot() {
	print "Writing new boot image to memory..."
	if $use_dd; then
		dd if="$tmp/boot-new.img" of="$boot_block" bs=131072
	else
		flash_image "$boot_block" "$tmp/boot-new.img"
	fi
	[ $? = 0 ] || abort "Failed to write boot image! You may need to restore your boot partition"
}

## end install methods

## start boot image patching

find_boot

dump_boot

build_boot

samsung_tag

verify_size

write_boot

## end boot image patching
