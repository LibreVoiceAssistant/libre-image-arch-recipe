#!/bin/bash


BASE_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BASE_DIR}" || exit 10

# Install system dependencies
pacman --noconfirm -Syyuu
pacman --noconfirm -Syu python-pip i2c-tools pulseaudio pulseaudio-zeroconf alsa-utils git
CFLAGS="-fcommon" pip install smbus smbus2 spidev rpi.gpio

# Disable userspace pulseaudio services
systemctl --global disable pulseaudio.service pulseaudio.socket

# Copy required overlay files
cd ${BASE_DIR} || exit 10
cp -r overlay/* /

# Ensure python bin exists for added scripts
if [ ! -f "/usr/bin/python" ]; then
  ln -s /usr/bin/python3 /usr/bin/python
fi

# Enable system services
systemctl enable pulseaudio.service

echo "Audio Setup Complete"
