#!/system/bin/sh

MODDIR=${0%/*}

SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs

until [ "$(getprop sys.boot_completed)" = 1 ]; do sleep 1; done
until [ -d "/sdcard/Android" ]; do sleep 1; done

# hide custom roms
${SUSFS_BIN} add_sus_path /data/adbroot
${SUSFS_BIN} add_sus_path /system/addon.d

# hide suspicious mounts
${SUSFS_BIN} add_sus_mount /apex/com.android.art/bin/dex2oat64
${SUSFS_BIN} add_sus_mount /apex/com.android.art/bin/dex2oat32



# hide revanced
packages="com.google.android.youtube com.google.android.apps.youtube.music"

hide_app () {
	for path in $(pm path $1 | cut -d: -f2) ; do ${SUSFS_BIN} add_sus_mount $path ; done
}
for i in $packages ; do hide_app $i ; done 

