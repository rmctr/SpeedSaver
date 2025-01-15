#!/system/bin/sh
# Copyright (c) 2025, Noah Y. & Xaiphon

write() {
    echo -n $2 > $1
}
lock_val() {
	if [ -f ${2} ]; then
		chmod 0666 ${2}
		echo ${1} > ${2}
		chmod 0444 ${2}
	fi
}

until [ "$(getprop sys.boot_completed)" = "1" ] && \
[ -d "/sdcard/Android" ]; do
  sleep 3
done

MODDIR=${0%/*}
BASEDIR="$(dirname $(readlink -f "$0"))"

# SpeedSaver folder location
CON_PATH="/sdcard/Android/SpeedSaver"

# Vsync 
set start vsync

# Freeze cached apps
settings put global cached_apps_freezer true

# MIUI proximity sensor fix, too anecdotal
#settings put global enable_screen_on_proximity_sensor 1

# Enable Zygote preforking
am broadcast -a \"com.google.android.gms.phenotype.FLAG_OVERRIDE\" --es package \"com.google.android.platform.runtime_native\" --es user \"\*\" --esa flags \"usap_pool_enabled\" --esa values \"true\" --esa types \"string\" com.google.android.gms

# Set fstrim every reboot
settings put global fstrim_mandatory_interval 1

# Disable logging
write "/sys/module/earlysuspend/parameters/debug_mask" 0
write "/sys/module/alarm/parameters/debug_mask" 0
write "/sys/module/alarm_dev/parameters/debug_mask" 0
write "/sys/module/binder/parameters/debug_mask" 0
write "/sys/devices/system/edac/cpu/log_ce" 0
write "/sys/devices/system/edac/cpu/log_ue" 0
write "/sys/module/binder/parameters/debug_mask" 0
write "/sys/module/bluetooth/parameters/disable_ertm" "Y"
write "/sys/module/bluetooth/parameters/disable_esco" "Y"
write "/sys/module/debug/parameters/enable_event_log" 0
write "/sys/module/dwc3/parameters/ep_addr_rxdbg_mask" 0 
write "/sys/module/dwc3/parameters/ep_addr_txdbg_mask" 0
write "/sys/module/edac_core/parameters/edac_mc_log_ce" 0
write "/sys/module/edac_core/parameters/edac_mc_log_ue" 0
write "/sys/module/glink/parameters/debug_mask" 0
write "/sys/module/hid_apple/parameters/fnmode" 0
write "/sys/module/hid_magicmouse/parameters/emulate_3button" "N"
write "/sys/module/hid_magicmouse/parameters/emulate_scroll_wheel" "N"
write "/sys/module/ip6_tunnel/parameters/log_ecn_error" "N"
write "/sys/module/lowmemorykiller/parameters/debug_level" 0
write "/sys/module/mdss_fb/parameters/backlight_dimmer" "N"
write "/sys/module/msm_show_resume_irq/parameters/debug_mask" 0
write "/sys/module/msm_smd/parameters/debug_mask" 0
write "/sys/module/msm_smem/parameters/debug_mask" 0 
write "/sys/module/otg_wakelock/parameters/enabled" "N" 
write "/sys/module/service_locator/parameters/enable" 0 
write "/sys/module/sit/parameters/log_ecn_error" "N"
write "/sys/module/smem_log/parameters/log_enable" 0
write "/sys/module/smp2p/parameters/debug_mask" 0
write "/sys/module/touch_core_base/parameters/debug_mask" 0
write "/sys/module/usb_bam/parameters/enable_event_log" 0
write "/sys/module/printk/parameters/console_suspend" "Y"
write "/proc/sys/debug/exception-trace" 0
write "/proc/sys/kernel/printk" "0 0 0 0"
write "/proc/sys/kernel/compat-log" "0"
sysctl -e -w kernel.panic_on_oops=0
sysctl -e -w kernel.panic=0
if [ -e /sys/module/logger/parameters/log_mode ]; then
 write /sys/module/logger/parameters/log_mode 2
fi;
if [ -e /sys/module/printk/parameters/console_suspend ]; then
 write /sys/module/printk/parameters/console_suspend "Y"
fi;
for i in $(find /sys/ -name debug_mask); do
 write $i 0;
done
for i in $(find /sys/ -name debug_level); do
 write $i 0;
done
for i in $(find /sys/ -name edac_mc_log_ce); do
 write $i 0;
done
for i in $(find /sys/ -name edac_mc_log_ue); do
 write $i 0;
done
for i in $(find /sys/ -name enable_event_log); do
 write $i 0;
done
for i in $(find /sys/ -name log_ecn_error); do
 write $i 0;
done
for i in $(find /sys/ -name snapshot_crashdumper); do
 write $i 0;
done
sleep "0.1"
lock_val "off" "/proc/sys/kernel/printk_devkmsg"
write /proc/sys/kernel/printk_devkmsg "0"
write /proc/sys/kernel/sched_schedstats "0"

# Busybox implementation 
BASEDIR="$(dirname $(readlink -f "$0"))"
BIN_PATH="$BASEDIR/bin"

# Use private busybox
PATH="$BIN_PATH/busybox:$BIN_PATH:$PATH"

# SpeedSaver folder location
CON_PATH="/sdcard/Android/SpeedSaver/"

# Create busybox symlinks
$BIN_PATH/busybox/busybox --install -s $BIN_PATH/busybox

# Log file path
SQLITE_LOG="$CON_PATH/sqlite.txt"
# Function to log messages with a timestamp
log() {
    local log_file=$1
    local message=$2
    echo "$(date +"%m-%d-%Y %H:%M:%S") - $message" >> "$log_file"
}

# Initialize log file
echo "Optimization" > "$SQLITE_LOG"
log "$SQLITE_LOG" "Starting Automatic SQLite optimization"

# SQLite optimization
SQLITE_COUNT=0
SUCCESS_SQLITE=0
SQLITE_SUCCESSES=""
SQLITE_ERRORS=""

# Process all directories beginning with "/d"
for i in $(busybox find /d* -iname "*.db"); do
        # Exclude WeChat (potentially problematic)
	if [[ $i != *"com.tencent.mm"* ]]; then
		SQLITE_COUNT=$((SQLITE_COUNT + 1))
		/system/bin/sqlite3 $i 'VACUUM;' 2>/dev/null
		VACUUM_EXIT=$?
		/system/bin/sqlite3 $i 'REINDEX;' 2>/dev/null
		REINDEX_EXIT=$?
		if [ $VACUUM_EXIT -eq 0 ] && [ $REINDEX_EXIT -eq 0 ]; then
			SQLITE_SUCCESSES+="Successfully optimized $i\n"
			SUCCESS_SQLITE=$((SUCCESS_SQLITE + 1))
			log "$SQLITE_LOG" "Successfully optimized $i"
		else
			SQLITE_ERRORS+="Error optimizing $i\n"
			log "$SQLITE_LOG" "Error optimizing $i"
		fi
	fi
done

# Determine SQLite success or failure
if [ $SUCCESS_SQLITE -gt $((SQLITE_COUNT / 2)) ]; then
    log "$SQLITE_LOG" "SQLite Success: $SUCCESS_SQLITE out of $SQLITE_COUNT databases optimized"
else
    log "$SQLITE_LOG" "SQLite Failed: Only $SUCCESS_SQLITE out of $SQLITE_COUNT databases optimized"
fi

rm -rf "$CON_PATH/fstrim.txt"
touch "$CON_PATH/fstrim.txt"
# busybox fstrim partitions
fstrim -v /data >> "CON_PATH/fstrim.txt"
fstrim -v /cache >> "$CON_PATH/fstrim.txt"
fstrim -v /system >> "$CON_PATH/fstrim.txt"
fstrim -v /systen_ext >> "$CON_PATH/fstrim.txt"
fstrim -v /vendor >> "$CON_PATH/fstrim.txt"
fstrim -v /persist >> "$CON_PATH/fstrim.txt"
fstrim -v /boot >> "$CON_PATH/fstrim.txt"
fstrim -v / >> "$CON_PATH/fstrim.txt"

unset -f write
setsid nohup ktweak &
# Lower priorities for processes
setsid nohup low_pr_proc &
# Notification
su -lp 2000 -c "cmd notification post -S bigtext -t 'SpeedSaver' 'Tag' 'Optimizations complete.'"
sleep 10
setsid nohup gms_dis &
exit 0
