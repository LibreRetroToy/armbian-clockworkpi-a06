#!/bin/bash

# arguments: $RELEASE $LINUXFAMILY $BOARD $BUILD_DESKTOP
#
# This is the image customization script

# NOTE: It is copied to /tmp directory inside the image
# and executed there inside chroot environment
# so don't reference any files that are not already installed

# NOTE: If you want to transfer files between chroot and host
# userpatches/overlay directory on host is bind-mounted to /tmp/overlay in chroot
# The sd card's root path is accessible via $SDCARD variable.

RELEASE=$1
LINUXFAMILY=$2
BOARD=$3
BUILD_DESKTOP=$4
OVERLAY_PATH="/tmp/overlay"

Main() {
	InstallClockworkpiA06
} # Main

InstallClockworkpiA06() {
	# env
	export LANG=C LC_ALL="en_US.UTF-8"
	export DEBIAN_FRONTEND=noninteractive
	export APT_LISTCHANGES_FRONTEND=none

	# change root password
	echo root:root | chpasswd
	rm /root/.not_logged_in_yet

	# disable serial autologin
	rm -f /etc/systemd/system/getty@.service.d/override.conf
	rm -f /etc/systemd/system/serial-getty@.service.d/override.conf

	# add user
	USER=cpi
	adduser --quiet --disabled-password --home /home/"$USER" --gecos "$USER" "$USER"
	(
		echo $USER
		echo $USER
	) | passwd root >/dev/null 2>&1
	for additionalgroup in sudo netdev audio video disk tty users games dialout plugdev input bluetooth systemd-journal ssh; do
		usermod -aG "${USER}" "${USER}" 2>/dev/null
	done

	# locale
	LOCALES="en_US.UTF-8"
	locale-gen "${LOCALES}" >/dev/null 2>&1
	echo "export LC_ALL=$LOCALES" >>/home/"$USER"/.bashrc
	echo "export LANG=$LOCALES" >>/home/"$USER"/.bashrc
	echo "export LANGUAGE=$LOCALES" >>/home/"$USER"/.bashrc
	echo "export LC_ALL=$LOCALES" >>/home/"$USER"/.xsessionrc
	echo "export LANG=$LOCALES" >>/home/"$USER"/.xsessionrc
	echo "export LANGUAGE=$LOCALES" >>/home/"$USER"/.xsessionrc

	# autologin (xfce)
	mkdir -p /etc/lightdm/lightdm.conf.d
	cat <<-EOF >/etc/lightdm/lightdm.conf.d/22-armbian-autologin.conf
		[Seat:*]
		autologin-user=$USER
		autologin-user-timeout=0
		user-session=xfce
	EOF
	ln -sf /lib/systemd/system/lightdm.service /etc/systemd/system/display-manager.service

	# set up profile sync daemon on desktop systems
	touch /home/"$USER"/.Xauthority
	chown "$USER":"$USER" /home/"$USER"/.Xauthority
	chmod +x /etc/update-motd.d/*

	# select cinnamon session
	[[ -x $(command -v cinnamon) ]] && sed -i "s/user-session.*/user-session=cinnamon/" /etc/lightdm/lightdm.conf.d/11-armbian.conf
	[[ -x $(command -v cinnamon) ]] && sed -i "s/user-session.*/user-session=cinnamon/" /etc/lightdm/lightdm.conf.d/22-armbian-autologin.conf

	# set up build-in tools
	apt install -y ${OVERLAY_PATH}/blobs/devterm-thermal-printer_0.3_arm64.deb
	apt install -y ${OVERLAY_PATH}/blobs/devterm-thermal-printer-cups_0.1_arm64.deb
	apt install -y ${OVERLAY_PATH}/blobs/devterm-wiringpi-cpi_0.1_arm64.deb

	# install gearboxplus form https://github.com/Mihaylov93/gearboxplus
	apt install -y ${OVERLAY_PATH}/blobs/gearboxplus_2.0_arm64.deb

	# install tools
	apt update
	apt install -y -q arandr chromium vlc cpupower-gui xfce4-power-manager

	# clean up and force password change on first boot
	umount /proc/mdstat
	chage -d 0 root

} # InstallClockworkpiA06

Main "$@"
