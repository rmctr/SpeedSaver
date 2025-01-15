#!/system/bin/sh
# Copyright (c) 2025, Noah Y. & Xaiphon

until [ "$(getprop sys.boot_completed)" = "1" ] && \
[ -d "/sdcard/Android" ]; do
sleep 3
done

MODDIR=${0%/*}
BASEDIR="$(dirname $(readlink -f "$0"))"

/system/bin/sh /system/bin/SpeedSaverd &

exit 0
