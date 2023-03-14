#!/bin/bash


BASE_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BASE_DIR}" || exit 10

cp -r overlay/* /
chmod -R ugo+x /opt/ovos

# Add pulse groups
groupadd gpio
groupadd i2c
groupadd dialout
echo "Added Groups GPIO I2C Dialout"

useradd -m -G wheel,sys,audio,input,video,storage,lp,network,users,power,gpio,i2c,dialout,render -p ovos -s /bin/bash ovos

groupadd pulse
groupadd pulse-access
echo "Added Groups Pulse and Pulse Access"

# Add any expected groups
useradd -g pulse pulse
useradd -g pulse-access pulse-access
echo "Added Users Pulse and Pulse Access"

chpasswd < /opt/ovos/install/pass.txt

# Add ovos user to groups
usermod -a -G gpio ovos
usermod -a -G video ovos
usermod -a -G input ovos
usermod -a -G render ovos
usermod -a -G pulse ovos
usermod -a -G pulse-access ovos
usermod -a -G i2c ovos
usermod -a -G dialout ovos
echo "Added Groups For User OVOS"

# Add root user to groups
echo "Adding Root User To Pulse Group"
usermod -a -G pulse root
echo "Adding Root User To Pulse-Access Group"
usermod -a -G pulse-access root
echo "Completed: Added Groups For User Root"

echo "Adding Pulse User To Pulse-Access Group"
usermod -a -G pulse-access pulse
echo "Adding Pulse User To Audio Group"
usermod -a -G audio pulse
echo "Adding Pulse User To Video Group"
usermod -a -G video pulse
echo "Completed: Added Groups For User Pulse"

echo "Adding Pulse-Access User to Pulse Group"
usermod -a -G pulse pulse-access

echo "Adding Pulse-Access User to Audio Group"
usermod -a -G audio pulse pulse-access

echo "Adding Pulse-Access User to Video Group"
usermod -a -G video pulse pulse-access
echo "Completed: Added Groups For User Pulse Access"

# Enable new services
systemctl enable resize_fs.service

# Set TZ
# TODO - what default to select ?
echo "America/Los_Angeles" > /etc/timezone
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

pacman-key --init
pacman-key --populate archlinuxarm manjaro manjaro-arm

echo "Installing Base Deps"
pacman --noconfirm -Syyuu
pacman --noconfirm -Syu base-devel wget unzip raspberrypi-firmware raspberrypi-userland-aarch64-git glibc-locales
pacman --noconfirm -Syu python-setuptools python python-gobject libffi swig portaudio mimic mpg123 screen flac curl icu libjpeg-turbo jq pulseaudio pulseaudio-alsa fann sox python-pip python-virtualenv wireless_tools ntp dkms
pacman --noconfirm -R manjaro-arm-oem-install
pacman --noconfirm -R manjaro-arm-installer
pacman --noconfirm -R manjaro-arm-flasher

echo "Fixing Locale"
locale-gen
update-locale LANG=en_US.UTF-8

echo "Core Configuration Complete"
