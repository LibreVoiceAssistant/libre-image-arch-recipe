#!/bin/bash
# This needs to run as root

# Turn Off LEDs
sj201-reset-led
# Set fan speed to 0
i2cset -a -y 1 0x04 101 0 i
