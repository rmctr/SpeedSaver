#!/data/adb/magisk/busybox sh
# Copyright (c) 2025, Noah Y. & Xaiphon

# Checking for installation environment

if [ $BOOTMODE = true ]; then
    ui_print "- Finding root path"
    ROOT="$(find "$(magisk --path)" -maxdepth 2 -type d -name "mirror" -print)"
    ui_print "  Path: $ROOT"
else
    unset ROOT
fi

	# SpeedSaver folder location
	CON_PATH="/sdcard/Android/SpeedSaver/"
	mkdir -p $CON_PATH

    ui_print "  Setting permissions"
    set_perm_recursive $MODPATH 0 0 0755 0755
    set_perm $MODPATH/system/bin 0 2000 0755
	set_perm $MODPATH/bin 0 2000 0755
	set_perm_recursive $CON_PATH 0 0 0755 0755 u:object_r:system_file:s0
	ui_print "  Install complete"
