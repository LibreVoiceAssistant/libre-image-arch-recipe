#!/bin/bash


BASE_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BASE_DIR}" || exit 10

#kernel="5.15.56-1-MANJARO-ARM-RPI"
#kernel="5.4.0-1052-raspi"

# Install system dependencies
pacman --noconfirm -Syyuu
pacman --noconfirm -Syu python-pip i2c-tools pulseaudio pulseaudio-zeroconf alsa-utils git
CFLAGS="-fcommon" pip install smbus smbus2 spidev rpi.gpio

# Determine kernel with build directory
if [ "$(ls -1 /lib/modules | wc -l)" -gt 1 ]; then
    kernels=($(ls /lib/modules))
    echo "Looking for kernel with build dir in ${kernels[*]}"
    for k in "${kernels[@]}"; do
        if [ -d "/lib/modules/${k}/build" ]; then
            kernel="${k}"
            echo "Selected kernel ${kernel}"
            break
        fi
    done
    if [ -z ${kernel} ]; then
        echo "No build files available. Picking kernel=${kernels[0]}"
        kernel=${kernels[0]}
    fi
else
    kernel=$(ls /lib/modules)
    echo "Only one kernel available: ${kernel}"
fi

# Build and load Seed VoiceCard Driver
git clone https://github.com/HinTak/seeed-voicecard
cd seeed-voicecard || exit 10
sudo ./install.sh
depmod ${kernel} -a
# `modinfo -k ${kernel} vocalfusion-soundcard` should show the module info now

# Configure pulse user
# usermod -aG bluetooth pulse

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
systemctl enable seeed-voicecard.service

echo "Audio Setup Complete"
