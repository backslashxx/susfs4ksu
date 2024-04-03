#!/bin/sh
MODDIR=/data/adb/modules/susfs4ksu
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs
. ${MODDIR}/utils.sh

# debugging
# echo "susfs4ksu/post-mount: running" >> /dev/kmsg 

# do something

${SUSFS_BIN} add_sus_path /system/addon.d

# EOF
