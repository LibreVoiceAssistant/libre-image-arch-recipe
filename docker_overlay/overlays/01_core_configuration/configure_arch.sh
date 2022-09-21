#!/bin/bash


BASE_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BASE_DIR}" || exit 10

cp -r overlay/* /
chmod -R ugo+x /opt/ovos

# Add any expected groups
groupadd gpio
groupadd pulse
groupadd pulse-access
groupadd i2c
groupadd dialout

useradd -m -G wheel,sys,audio,input,video,storage,lp,network,users,power,gpio,i2c,dialout,render,pulse,pulse-access -p ovos -s /bin/bash ovos

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

# Enable new services
systemctl enable resize_fs.service

# Set TZ
# TODO - what default to select ?
echo "America/Los_Angeles" > /etc/timezone
rm /etc/localtime
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

pacman-key --init
pacman-key --populate archlinuxarm manjaro manjaro-arm

echo "Core Configuration Complete"
