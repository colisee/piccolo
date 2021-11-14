#!/bin/bash -e

# Install cloud-init related files
install -d				"${ROOTFS_DIR}/etc/cloud"
install -m 644 files/cloud.cfg		"${ROOTFS_DIR}/etc/cloud/"
install -m 644 files/meta-data		"${ROOTFS_DIR}/boot/"
install -m 644 files/user-data		"${ROOTFS_DIR}/boot/"

# Install setup files
install -m 644 files/myconfig		"${ROOTFS_DIR}/boot/"
install -d				"${ROOTFS_DIR}/usr/lib/piccolo"
install -m 744 files/initialize.sh	"${ROOTFS_DIR}/usr/lib/piccolo/"
install -m 744 files/finalize.sh	"${ROOTFS_DIR}/usr/lib/piccolo/"

# Install miscellaneous utilities
install -m 744 files/upgrade.sh		"${ROOTFS_DIR}/usr/lib/piccolo/"
install -m 644 files/piccolo		"${ROOTFS_DIR}/etc/cron.d/"

