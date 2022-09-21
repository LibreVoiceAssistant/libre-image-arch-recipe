#!/bin/bash
# This needs to run as root

# Enable Driver Overlay
dtoverlay xvf3510

# Flash xmos firmware
xvf3510-flash --direct /usr/lib/firmware/xvf3510/app_xvf3510_int_spi_boot_v4_1_0.bin
# Init TI Amp
tas5806-init
# Reset LEDs
sj201-reset-led
# Reset fan speed
i2cset -a -y 1 0x04 101 30 i
