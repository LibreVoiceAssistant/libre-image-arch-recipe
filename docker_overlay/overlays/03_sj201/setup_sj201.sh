#!/bin/bash

BASE_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BASE_DIR}" || exit 10

#kernel="5.15.56-1-MANJARO-ARM-RPI"
#kernel="5.4.0-1052-raspi"

# Copy required overlay files
cd ${BASE_DIR} || exit 10
cp -r overlay/* /
chmod -R ugo+x /usr/bin
chmod -R ugo+x /usr/sbin
chmod ugo+x /opt/ovos/configure_sj201_on_boot.sh

# Install system dependencies
pacman --noconfirm -Syyuu
pacman --noconfirm -Syu python-pip i2c-tools pulseaudio pulseaudio-zeroconf alsa-utils git dtc
CFLAGS="-fcommon" pip install smbus smbus2 spidev rpi.gpio

pip3 install sj201-interface
pip3 install git+https://github.com/NeonGeckoCom/neon-phal-plugin-linear_led
pip3 install git+https://github.com/NeonGeckoCom/neon-phal-plugin-switches
pip3 install git+https://github.com/NeonGeckoCom/neon-phal-plugin-fan

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

# Ensure python bin exists for added scripts
if [ ! -f "/usr/bin/python" ]; then
  ln -s /usr/bin/python3 /usr/bin/python
fi

# Enable system services
systemctl enable pulseaudio.service
systemctl enable sj201
systemctl enable sj201-shutdown
systemctl enable poweroff

revision=$(sj201 get-revision)
echo "Current SJ201 revision is: $revision"

if [ "${revision}" == "10" ]; then
    echo "Configuring SJ201 rev10 overlay driver and adding an on-boot overlay"
    dtc -@ -Hepapr -I dts -O dtb -o /boot/overlays/sj201-rev10-pwm-fan.dtbo /opt/ovos/builds/sj201/sj201-rev10-pwm-fan-overlay.dts
    echo -e "\ndtoverlay=sj201-rev10-pwm-fan" >> /boot/config.txt
fi

echo "Audio Setup Complete"

