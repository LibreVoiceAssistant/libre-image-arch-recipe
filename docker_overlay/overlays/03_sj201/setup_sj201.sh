#!/bin/bash


BASE_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BASE_DIR}" || exit 10

kernel=$(ls /lib/modules)
#kernel="5.4.0-1052-raspi"

# Install system dependencies
pacman --noconfirm -Syyuu
pacman --noconfirm -Syu base-devel python-pip i2c-tools raspberrypi-firmware pulseaudio pulseaudio-zeroconf alsa-utils git
CFLAGS="-fcommon" pip install smbus smbus2 spidev rpi.gpio

# Build and load VocalFusion Driver
git clone https://github.com/OpenVoiceOS/vocalfusiondriver
cd vocalfusiondriver/driver || exit 10
sed -ie "s|\$(shell uname -r)|${kernel}|g" Makefile
make all || exit 2
mkdir "/lib/modules/${kernel}/kernel/drivers/vocalfusion"
cp vocalfusion* "/lib/modules/${kernel}/kernel/drivers/vocalfusion" || exit 2
depmod ${kernel} -a
# `modinfo -k ${kernel} vocalfusion-soundcard` should show the module info now

# Configure pulse user
# usermod -aG bluetooth pulse

# Disable userspace pulseaudio services
systemctl --global disable pulseaudio.service pulseaudio.socket

# Copy required overlay files
cd ${BASE_DIR} || exit 10
cp -r overlay/* /
chmod -R ugo+x /usr/bin
chmod -R ugo+x /usr/sbin
chmod ugo+x /opt/ovos/configure_sj201_on_boot.sh

# Ensure python bin exists for added scripts
if [ ! -f "/usr/bin/python" ]; then
  ln -s /usr/bin/python3 /usr/bin/python
fi

# Enable system services
systemctl enable pulseaudio.service
systemctl enable sj201
systemctl enable sj201-shutdown

echo "Audio Setup Complete"
