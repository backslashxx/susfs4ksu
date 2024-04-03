#!/bin/sh
MODDIR=/data/adb/modules/susfs4ksu
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs
TMPFS_DIR="/debug_ramdisk/susfs4ksu"
mkdir -p "$TMPFS_DIR"

# we handle the mounting ourselves
[ ! -f ${MODDIR}/skip_mount ] && touch ${MODDIR}/skip_mount
. ${MODDIR}/utils.sh
detect_susfs_status

# debugging
# echo "susfs4ksu/post-fs-data: running" >>/dev/kmsg 

#### add your own modifications below

# uname spoof
# getprop ro.product.name | grep -E 'daisy|sakura' && ${SUSFS_BIN} set_uname '3.18.124-perf-g48df2b1' '#1 SMP PREEMPT Wed Jun 30 16:43:43 WIB 2021'
# getprop ro.product.name | grep -E 'sunny|mojito' && ${SUSFS_BIN} set_uname '4.14.190-perf-gcfbf768af191' '#1 SMP PREEMPT Wed Oct 18 19:50:14 CST 2023'

# EOF
