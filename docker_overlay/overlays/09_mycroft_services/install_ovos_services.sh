#!/bin/bash


BASE_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BASE_DIR}" || exit 10
cp -rf overlay/* / || exit 2

# Make sure installed packages are properly owned
chown -R ovos:ovos /home/ovos

# Enable all the services
systemctl enable mycroft.service
systemctl enable mycroft-messagebus.service
systemctl enable mycroft-skills.service
systemctl enable mycroft-enclosure-gui.service
systemctl enable mycroft-voice.service
systemctl enable mycroft-audio.service
systemctl enable mycroft-phal.service
systemctl enable mycroft-gui.service

echo "OVOS Services installed"
