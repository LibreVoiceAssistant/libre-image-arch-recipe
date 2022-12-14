#!/bin/bash


BASE_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BASE_DIR}" || exit 10
cp -rf overlay/* / || exit 2

# Make sure installed packages are properly owned
chown -R ovos:ovos /home/ovos

chmod 777 /home/ovos/.local/share/systemd/mycroft-systemd_messagebus.py
chmod 777 /home/ovos/.local/share/systemd/mycroft-systemd_audio.py
chmod 777 /home/ovos/.local/share/systemd/mycroft-systemd_gui.py
chmod 777 /home/ovos/.local/share/systemd/mycroft-systemd_phal.py
chmod 777 /home/ovos/.local/share/systemd/mycroft-systemd_voice.py
chmod 777 /home/ovos/.local/share/systemd/mycroft-systemd_skills.py

mkdir -p /var/log/ovos/
chmod -R 777 /var/log/ovos/

# Enable all the services
systemctl enable mycroft.service
systemctl enable mycroft-messagebus.service
systemctl enable mycroft-skills.service
systemctl enable mycroft-enclosure-gui.service
systemctl enable mycroft-voice.service
systemctl enable mycroft-audio.service
systemctl enable mycroft-phal.service
systemctl enable mycroft-gui.service

systemctl enable pulseaudio.service
systemctl enable NetworkManager.service

systemctl disable systemd-firstboot.service

pacman --noconfirm -R manjaro-arm-oem-install

echo "OVOS Services installed"
