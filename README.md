# Kernel Flasher by jcadduono

## To use:

Place a `zImage`/`Image.gz` (or any other variation of a kernel image) along with an optional `dtb.img` in the root directory and it will automatically be flashed by the zip.

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
replace_file <old file> <new file> - replace a file, preserving metadata (using cat)
replace_line <file> <line match mattern> <replacement line> - replace a matching line in a file with another line
insert_after_last <file> <line match pattern> <inserted line> - insert a specified line after the last matching line
setperm <directory permissions> <file permissions> <directory> - recursively sets permissions of files & directories
setcmdline <key> <value> - set a key's value on the boot image's initial command line
setprop <prop> <value> - set a prop value in default.prop
delprop <prop> - delete a prop from both default.prop and build.prop
disable_service <service> - searches init rc files and sets the matching service to disabled
remove_service <service> - searches init rc files and comments out all references to the matching service
ueventd_set <device node> <permissions> <chown> <chgrp> - use this to set permissions of /dev nodes
context_set <file path regex> <context> - use this to set selinux contexts of file paths
import_rc <rc file> - adds an init rc file as an import to init.rc, it will be imported last
secheck [-s <source type>] [-c <class>] - check if a given context label or class exists in the sepolicy
seadd [-Z / -z <domain> | -s <source type>] [-t <target type>] [-c <class>] [-z <domain>] [-p <perm,list>] [-a <type attr>] - add a new policy rule/domain to the sepolicy
```
Variables available to patch.d scripts:
```
$found_prop - true if default.prop exists in the ramdisk
$found_build_prop - true if build.prop exists in /system
$found_ueventd - true if ueventd.rc exists in the ramdisk
$found_sepolicy - true if sepolicy exists in the ramdisk
$found_file_contexts - true if file_contexts exists in the ramdisk
$android_api - Android API version estimated from sepolicy rules (19 <= K, 21 = L, 23 = M, 24 >= N)
$tmp - full path to installation extraction root (ex. /tmp/kernel-flasher)
$ramdisk - full path to extracted ramdisk root (current directory of patch.d scripts)
$ramdisk_patch - full path to new ramdisk files (applied automatically over the current ramdisk)
$split_img - full path to extracted contents of boot image (including cmdline)
$modules - full path to directory containing kernel modules for install to /system/lib/modules
$bin - full path to recovery executable binaries (ex. unpackbootimg, mkbootimg)
```
