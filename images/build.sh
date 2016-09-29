#!/bin/sh

set -e

if [ $(lsb_release -cs) = "wheezy" ]; then
	echo "deb http://http.debian.net/debian jessie main contrib non-free"> /etc/apt/sources.list.d/jessie.list
	echo jessie source added.
fi

# Install requirements
apt-get update
apt-get -y -t jessie install live-build live-config live-config-systemd live-boot isolinux syslinux-common

# Patch live build binary_syslinux to support multi cfg.in files
EXEC_PATCH() { patch --backup-if-mismatch --forward /usr/lib/live/build/binary_syslinux ./binary_syslinux_patch; }
EXEC_PATCH || true

_FLAVOURS="gnome"
_NAME="wahalinux-8.6"
_SETS="unofficial"
_SUFFIX=""
_ARCHITECTURE="$(dpkg --print-architecture)"

for _FLAVOUR in ${_FLAVOURS}
do
	cd ${_FLAVOUR}
	for _SET in ${_SETS}
	do
		# iso-hybrid
		lb config
		lb build

		mv build.log 						${_NAME}-${_ARCHITECTURE}-${_FLAVOURS}${_SUFFIX}.iso.log
		mv live-image-${_ARCHITECTURE}.contents 		${_NAME}-${_ARCHITECTURE}-${_FLAVOURS}${_SUFFIX}.iso.contents
		mv live-image-${_ARCHITECTURE}.hybrid.iso 		${_NAME}-${_ARCHITECTURE}-${_FLAVOURS}${_SUFFIX}.iso
		mv live-image-${_ARCHITECTURE}.hybrid.iso.zsync 	${_NAME}-${_ARCHITECTURE}-${_FLAVOURS}${_SUFFIX}.iso.zsync
		mv live-image-${_ARCHITECTURE}.packages 		${_NAME}-${_ARCHITECTURE}-${_FLAVOURS}${_SUFFIX}.iso.packages
		mv ${_NAME}-${_ARCHITECTURE}-${_FLAVOURS}${_SUFFIX}.iso* ../
		#lb clean
	done
	cd ..
	#rm -rf ${_FLAVOUR}
done
