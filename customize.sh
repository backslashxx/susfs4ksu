#!/bin/sh
. $MODPATH/utils.sh
	
chmod 755 ${MODPATH}/tools/ksu_susfs_arm64
echo "[+] moving ksu_susfs to /data/adb/ksu/bin"
mv -f ${MODPATH}/tools/ksu_susfs_arm64 /data/adb/ksu/bin/ksu_susfs

# EOF
