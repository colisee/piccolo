#!/bin/bash

##  Copyright (C) 2021  Robin ALEXANDER
##
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program.  If not, see <https://www.gnu.org/licenses/>.

## Goal: change the cloud-init user-data file with the information coming from file /boot/myconfig

# Mount
mount -t proc proc /proc
mount -t sysfs sys /sys
mount -t tmpfs tmp /run
mkdir -p /run/systemd

mount /boot
mount / -o remount,ro

# Retrieve the servet setup values 
source /boot/myconfig

# cloud-init: Change the server, administrator profile and password in /boot/user-data
sed -i /boot/user-data -e "s/hostname: initialize/hostname: ${SERVER}/" 
sed -i /boot/user-data -e "s/name: initialize/name: ${ADMIN_USER}/" 
sed -i /boot/user-data -e "s/plain_text_passwd: initialize/plain_text_passwd: ${ADMIN_PASSWORD}/" 

# Remove this program from /boot/cmdline.txt
sed -i /boot/cmdline.txt -e "s; init=/usr/lib/piccolo/initialize.sh;;"

# Sync the changes
mount /boot -o remount,ro
sync

# Unmount everything and call the original init_resize.sh
umount /proc
umount /sys
umount /run
umount /boot
/usr/lib/raspi-config/init_resize.sh

