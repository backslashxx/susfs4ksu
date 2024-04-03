#!/bin/sh
MODDIR=/data/adb/modules/susfs4ksu
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs
. ${MODDIR}/utils.sh
update_susfs_status

until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 1
done

#### add your own modifications below

# Holmes 1.5+ Futile Trace Hide
# look for a loop that has a journal
#for device in $(ls -Ld /proc/fs/jbd2/loop*8 | sed 's|/proc/fs/jbd2/||; s|-8||'); do 
#	${SUSFS_BIN} add_sus_path /proc/fs/jbd2/${device}-8
#	${SUSFS_BIN} add_sus_path /proc/fs/ext4/${device}
#done

# hide lineage (almost all custom roms have this)
for i in $(find /system /vendor /system_ext /product -iname *lineage* -o -iname *crdroid* ) ; do ${SUSFS_BIN} add_sus_path $i ; done

# hide gapps installation traces
for i in $(find /system /vendor /system_ext /product -iname *gapps* ) ; do ${SUSFS_BIN} add_sus_path $i ; done

# reveny's lineage detection workaround
remove_lineage() {
	TMPFS_DIR="/debug_ramdisk/susfs4ksu"
	mkdir -p $TMPFS_DIR/${1%/*}
	grep -v "lineage" $1 > $TMPFS_DIR/$1
	susfs_clone_perm $TMPFS_DIR/$1 $1
	mount --bind $TMPFS_DIR/$1 $1
	${SUSFS_BIN} add_sus_mount $1
}

remove_lineage /vendor/etc/selinux/vendor_sepolicy.cil
remove_lineage /system/etc/vintf/compatibility_matrix.device.xml

# EOF
