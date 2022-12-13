#!/bin/bash


BASE_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BASE_DIR}" || exit 10

cp -r overlay/* /
chmod -R ugo+x /opt/ovos

# Add any expected groups
useradd -s /bin/bash pulse
useradd -s /bin/bash pulse-access

groupadd gpio
groupadd pulse
groupadd pulse-access
groupadd i2c
groupadd dialout

useradd -m -G wheel,sys,audio,input,video,storage,lp,network,users,power,gpio,i2c,dialout,render,pulse,pulse-access -p ovos -s /bin/bash ovos

chpasswd < /opt/ovos/install/pass.txt

# Add ovos user to groups
usermod -aG gpio ovos
usermod -aG video ovos
usermod -aG input ovos
usermod -aG render ovos
usermod -aG pulse ovos
usermod -aG pulse-access ovos
usermod -aG i2c ovos
usermod -aG dialout ovos

# Add root user to groups
usermod -aG pulse root
usermod -aG pulse-access root

# Add pulse user to groups

usermod -aG pulse pulse
usermod -aG pulse-access pulse
usermod -aG audio pulse
usermod -aG video pulse
usermod -aG render pulse

usermod -aG pulse pulse-access
usermod -aG pulse-access pulse-access
usermod -aG audio pulse pulse-access
usermod -aG video pulse pulse-access
usermod -aG render pulse pulse-access

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
