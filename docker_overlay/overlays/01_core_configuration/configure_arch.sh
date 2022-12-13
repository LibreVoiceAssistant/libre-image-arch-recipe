#!/bin/bash


BASE_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BASE_DIR}" || exit 10

cp -r overlay/* /
chmod -R ugo+x /opt/ovos

# Add pulse groups
groupadd pulse
groupadd pulse-access
echo "Added Groups Pulse and Pulse Access"

# Add any expected groups
useradd -s /bin/bash pulse
useradd -s /bin/bash pulse-access
echo "Added Users Pulse and Pulse Access"

groupadd gpio
groupadd pulse
groupadd pulse-access
groupadd i2c
groupadd dialout

useradd -m -G wheel,sys,audio,input,video,storage,lp,network,users,power,gpio,i2c,dialout,render,pulse,pulse-access -p ovos -s /bin/bash ovos

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
usermod -a -G pulse root
usermod -a -G pulse-access root
echo "Added Groups For User Root"

# Add pulse user to groups
usermod -a -G pulse pulse
usermod -a -G pulse-access pulse
usermod -a -G audio pulse
usermod -a -G video pulse
usermod -a -G render pulse
echo "Added Groups For User Pulse"

usermod -a -G pulse pulse-access
usermod -a -G pulse-access pulse-access
usermod -a -G audio pulse pulse-access
usermod -a -G video pulse pulse-access
usermod -a -G render pulse pulse-access
echo "Added Groups For User Pulse Access"

# Enable new services
systemctl enable resize_fs.service

# Set TZ
# TODO - what default to select ?
echo "America/Los_Angeles" > /etc/timezone
rm /etc/localtime
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

pacman-key --init
pacman-key --populate archlinuxarm manjaro manjaro-arm

echo "Installing Base Deps"
pacman --noconfirm -Syyuu
pacman --noconfirm -Syu base-devel wget unzip raspberrypi-firmware raspberrypi-userland-aarch64-git glibc-locales
pacman --noconfirm -R manjaro-arm-oem-install
pacman --noconfirm -Syu python-setuptools python python-gobject libffi swig portaudio mimic mpg123 screen flac curl icu libjpeg-turbo jq pulseaudio pulseaudio-alsa fann sox python-pip python-virtualenv

echo "Fixing Locale"
locale-gen
update-locale LANG=en_US.UTF-8

echo "Core Configuration Complete"
