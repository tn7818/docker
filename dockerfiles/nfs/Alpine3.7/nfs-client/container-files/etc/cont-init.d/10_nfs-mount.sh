#!/bin/sh

set -e

# FSTYPE
if [ -z "$FSTYPE" ]; then
	MOUNTFSTYPE='nfs4'
else
	MOUNTFSTYPE=${FSTYPE}
fi

# MOUNT_TARGET
if [ -z "$MOUNT_TARGET" ]; then
	MOUNTTARGET='localhost:/export'
else
	MOUNTTARGET=${MOUNT_TARGET}
fi

# MOUNT_POINT
if [ -z "$MOUNT_POINT" ]; then
	MOUNTPOINT='/nfs'
else
	MOUNTPOINT=${MOUNT_POINT}
fi

# MOUNT_OPTIONS
if [ -z "$MOUNT_OPTIONS" ]; then
	MOUNTOPTIONS='nolock'
else
	MOUNTOPTIONS=${MOUNT_OPTIONS}
fi

if [ ! -d "$MOUNTPOINT" ]; then
	mkdir -p ${MOUNTPOINT}
fi

rpcbind

mount -t ${MOUNTFSTYPE} -o ${MOUNTOPTIONS} ${MOUNTTARGET} ${MOUNTPOINT}

