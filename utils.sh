#!/bin/sh
MODDIR=/data/adb/modules/susfs4ksu
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs

## susfs_clone_perm <file/or/dir/perm/to/be/changed> <file/or/dir/to/clone/from>
susfs_clone_perm() {
	TO=$1
	FROM=$2
	if [ -z "${TO}" -o -z "${FROM}" ]; then
		return
	fi
	CLONED_PERM_STRING=$(stat -c "%a %U %G" ${FROM})
	set ${CLONED_PERM_STRING}
	chmod $1 ${TO}
	chown $2:$3 ${TO}
	busybox chcon --reference=${FROM} ${TO}
}

## susfs_hexpatch_props <target_prop_name> <spoofed_prop_name> <spoofed_prop_value>
susfs_hexpatch_props() {
	TARGET_PROP_NAME=$1
	SPOOFED_PROP_NAME=$2
	SPOOFED_PROP_VALUE=$3
	if [ -z "${TARGET_PROP_NAME}" -o -z "${SPOOFED_PROP_NAME}" -o -z "${SPOOFED_PROP_VALUE}" ]; then
		return 1
	fi
	if [ "${#TARGET_PROP_NAME}" != "${#SPOOFED_PROP_NAME}" ]; then
		return 1
	fi
	resetprop -n ${TARGET_PROP_NAME} ${SPOOFED_PROP_VALUE}
	magiskboot hexpatch /dev/__properties__/$(resetprop -Z ${TARGET_PROP_NAME}) $(echo -n ${TARGET_PROP_NAME} | xxd -p | tr "[:lower:]" "[:upper:]") $(echo -n ${SPOOFED_PROP_NAME} | xxd -p | tr "[:lower:]" "[:upper:]")
}

# susfs detect status
detect_susfs_status() {
	dmesg | grep "susfs_init" > /dev/null && touch /debug_ramdisk/susfs_active
}

# susfs update status
update_susfs_status() {
	if [ -f /debug_ramdisk/susfs_active ]; then
		# susfs log toggle
		if [ -f ${MODDIR}/susfs_log_enable ]; then
			${SUSFS_BIN} enable_log 1
			desription="description=status: active ✅ | logging: enabled ✅"
		else
			${SUSFS_BIN} enable_log 0
			desription="description=status: active ✅ | logging: disabled ❌"
		fi	
	else
		desription="description=status: failed 💢 - Make sure youre on a SuSFS-patched kernel! "
		# might as well disable ourselves
		touch ${MODDIR}/disable
		# disable action usage
		# rm ${MODDIR}/action.sh 
	fi
	sed -i "s/^description=.*/$desription/g" $MODDIR/module.prop
}

# EOF
