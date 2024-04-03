#!/bin/sh
MODDIR=/data/adb/modules/susfs4ksu
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs
. ${MODDIR}/utils.sh

# debugging
# echo "susfs4ksu/action: trigerred!" >>/dev/kmsg 


if [ ! -f /debug_ramdisk/susfs_active ]; then
	desription="description=status: failed 💢 - Make sure youre on a SuSFS-patched kernel! "
	sed -i "s/^description=.*/$desription/g" $MODDIR/module.prop
	# might as well disable ourselves
	touch ${MODDIR}/disable 
	# is there a better word for this?
	echo "susfs4ksu/action: 😭😭😭 "
	echo "susfs4ksu/action: susfs kernel not found 💢"
	echo "susfs4ksu/action: ❌❌❌ "
	sleep 10
	exit 1
fi

echo "susfs4ksu/action: action.sh "
echo "susfs4ksu/action: log_enable toggle"

if [ -f ${MODDIR}/susfs_log_enable ]; then
	rm ${MODDIR}/susfs_log_enable
	${SUSFS_BIN} enable_log 0
	echo "susfs4ksu/action: logging disabled! ❌"
	desription="description=status: active ✅ | logging: disabled ❌"
else
	touch ${MODDIR}/susfs_log_enable
	${SUSFS_BIN} enable_log 1
	echo "susfs4ksu/action: logging enabled! ✅"
	desription="description=status: active ✅ | logging: enabled ✅"
fi

sed -i "s/^description=.*/$desription/g" $MODDIR/module.prop

# debugging
# echo "This 10s wait time is intentional."
# sleep 10

sleep 5
exit 1
# EOF
