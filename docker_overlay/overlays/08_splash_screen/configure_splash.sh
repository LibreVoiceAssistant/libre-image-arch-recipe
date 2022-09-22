#!/bin/bash


BASE_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BASE_DIR}" || exit 10
cp -rf overlay/* / || exit 2

# # Install image viewer
# apt update
# apt install -y fbi
pacman --noconfirm -Syu fbida

# Disable terminal and enable splash on boot
systemctl disable getty@tty1
systemctl enable splashscreen

echo "Splash Screen Configured"
