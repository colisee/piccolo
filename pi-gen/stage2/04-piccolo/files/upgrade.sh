#!/bin/bash

# Log the current date
echo $(date)

# Upgrade the system
apt-get update
apt-get dist-upgrade -y
apt-get autoremove -y
apt-get clean -y

# Reboot the system
systemctl reboot
