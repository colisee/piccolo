# Table of contents:
- [Introduction](#introduction)
- [Build the disk image](#build-the-disk-image)
- [Run the piccolo system](#run-the-piccolo-system)

# Introduction
`piccolo` is a linux operating system based on raspios-lite and aims at running personal cloud services on a [raspberry-pi](https://www.raspberrypi.org/) device. 

Compared to raspios-lite/pi-gen, `piccolo`:
- Deactivates audio, bluetooth and wifi capabilities to reduce CPU and memory footprints
- Activates ssh
- Creates an admin profile based on the values of a configuration file that must be customized before the system is booted the first time in order to improve security
- Installs the software packages [cloud-init](https://cloud-init.io) [docker.io](https://www.docker.com/), [cockpit-dashboard](https://cockpit-project.org)
- Implements a daily (at 03:00 local time) system upgrade and system reboot to keep the system in perfect security conditions
- Loads and run the docker images:
  - [nginxproxy/nginx-proxy](https://github.com/nginx-proxy/nginx-proxy): reverse web proxy
  - [nginxproxy/acme-companion](https://github.com/nginx-proxy/acme-companion): automated web certificate management
  - [postgres](https://www.postgresql.org): sql-type database
  - [nextcloud](https://nextcloud.com): nextcloud service
  - [weejewel/wg-easy](https://github.com/WeeJeWel/wg-easy): wireguard vpn with web management 
# Build the disk image 
The build-up of `piccolo` is based on the [pi-gen](https://github.com/RPi-Distro/pi-gen) project.
## Pre-requisites
- Install git, [virtualbox](https://www.virtualbox.org/), [vagrant](https://www.vagrantup.com/) and [rpi-imager](https://www.raspberrypi.com/news/raspberry-pi-imager-imaging-utility) on your PC
- Clone the piccolo repository (git clone https://github.com/colisee/piccolo.git)
## Building the disk image
- Open a terminal session
- cd *path_to_the_piccolo_repository*
- Start a debian virtual session `vagrant up`
- Log into the virtual session `vagrant ssh`
- Access the build directory `cd /vagrant/pi-gen`
- Start the building process `sudo ./build-docker.sh`
- When the building process is completed, you should see the following message "Done! Your image(s) should be in deploy/"
- Log off your virtual session `exit`
- Delete the virtual session `vagrant destroy`
## Writing the disk image to the SD card
- Insert the SD card into your pc
- Run rpi-imager
- Select the zipped disk image file, located in pi-gen/deploy
- Select the SD card 
- Click on the write button
- Remove the SD card when the writing process is completed
# Run the piccolo system
## Customizing the configuration (mandatory)
- Insert the SD card again into your PC
- Open the "boot" drive
- Modify the `myconfig` file by changing the values of the following fields
  - SERVER: name of the server
  - DOMAIN: domain where the server can be reached from the internet
  - ADMIN_USER: profile of the administration user
  - ADMIN_PASSWORD: password of the administration user
- Save the `myconfig` file
- Eject your SD card and remove it from your PC when told so
## Starting the raspberry pi server
- Insert your SD card into your raspberry-pi device
- If possible, connect your raspberry-pi server to a display (using a HDMI cable) to monitor the boot sequence
- Switch your raspberry-pi device on
- Wait at least 5 minutes for the first boot sequence to complete, for the system will apply system upgrades (if any) and load the last versions of several required applications
## Accessing the raspberry-pi server for system administration purposes
- Use a device (PC, tablet, smartphone) that is connected to the same network as the raspberry pi server
- Open your web navigator and point it to https://*value_of_field_SERVER_in_file_myconfig*.local:9090 
- A certificate security warning will be displayed because the certificate is auto-signed. Accept the risk and proceed
- Sign in with the administrator user credentials and check the option "Reuse my password for privileged tasks"
## Accessing the nextcloud service
- Open your web navigator and point it to https://cloud.*value_of_field_DOMAIN_in_file_myconfig*
## Accessing the wireguard web administration console
- Open your navigator abd point it to http://*value_of_field_SERVER_in_file_myconfig*.local:51821
