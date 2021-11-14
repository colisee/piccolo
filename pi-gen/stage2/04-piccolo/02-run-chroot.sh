#!/bin/bash -e

# Audio off
sed -i -e "s/dtparam=audio=on/dtparam=audio=off/" /boot/config.txt

# Disable bluetooth and wifi
echo "dtoverlay=disable-bt" >> /boot/config.txt
echo "dtoverlay=disable-wifi" >> /boot/config.txt

