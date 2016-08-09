# Kernel Flasher by jcadduono

## To use:

Place a `zImage` and/or `dtb.img` in root directory and it will automatically be flashed by the zip.

To create a zip file, use `make`.

You can modify the Makefile and update-binary (a shell script) to print installation messages, and add custom scripts to the patch.d folder.

Template for patch.d script:
```sh
#!/sbin/sh

. "$env"

# add your scripts here

exit 0
```

## You can also add your own functions to `patch.d-env`.

Existing functions available to patch.d scripts:
```
abort <error message> - aborts the installation and prints an error message
print <message> - prints a message to the installation console
replace_line <file> <line match mattern> <replacement line> - replace a matching line in a file with another line
insert_after_last <file> <line match pattern> <inserted line> - insert a specified line after the last matching line
setprop <prop> <value> - set a prop value in default.prop (primary) and removes duplicates from build.prop (secondary)
delprop <prop> - delete a prop from both default.prop and build.prop
```
Variables available to patch.d scripts:
```
$found_prop - true if default.prop exists in the ramdisk
$found_build_prop - true if build.prop exists in /system
$tmp - full path to installation extraction root (ex. /tmp/kernel-flasher)
$ramdisk - full path to extracted ramdisk root (current directory of patch.d scripts)
$ramdisk_patch - full path to new ramdisk files (applied automatically over the current ramdisk)
$split_img - full path to extracted contents of boot image (including cmdline)
$modules - full path to directory containing kernel modules for install to /system/lib/modules
$bin - full path to recovery executable binaries (ex. unpackbootimg, mkbootimg)
```
