#!/bin/bash


BASE_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BASE_DIR}" || exit 10

pacman --noconfirm -Syyuu
pacman --noconfirm -Syu networkmanager

# Setup all the services
systemctl disable systemd-networkd.socket
systemctl disable systemd-networkd
systemctl disable wpa_supplicant.service

# Add wifi-connect binary
cp -r overlay/* /
chmod -R ugo+x /usr/local/sbin
chmod -R ugo+x /opt/ovos
chown root:netdev /usr/bin/nmcli
# Configure networking check on startup and restart
systemctl enable wifi-setup.service

# Patch SSH service
cd /etc/ssh || exit 10
ssh-keygen -A
sed -ie "s|PasswordAuthentication no|PasswordAuthentication yes|g" /etc/ssh/sshd_config

echo "Network Setup Complete"
