#!/bin/bash

export XDG_CONFIG_HOME="/home/ovos/.config"
export XDG_DATA_HOME="/home/ovos/.local/share"
export XDG_CACHE_HOME="/home/ovos/.cache"

BASE_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BASE_DIR}" || exit 10
# Copy overlay files (default configuration)
cd "${BASE_DIR}" || exit 10
cp -rf overlay/* / || exit 2
cd /home/ovos || exit 2

# Upgrade pip
pip3 install --upgrade pip

# Generic dependencies
pip3 install wheel
pip3 install sdnotify

# Lets try the tflite stuff in 3.10
pip3 install numpy==1.23.5
pip3 install https://downloads.openvoiceos.com/tflite_runtime-2.12.0-cp310-cp310-linux_aarch64.whl

# Install Core
pip3 install "git+https://github.com/OpenVoiceOS/ovos-core#egg=ovos_core[all]" || exit 11
echo "Core Installed"

# Download model files
mkdir -p /home/ovos/.local/share/mycroft
wget -O /home/ovos/.local/share/mycroft/vosk-model-small-en-us-0.15.zip https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip
cd /home/ovos/.local/share/mycroft || exit 10
unzip vosk-model-small-en-us-0.15.zip
rm vosk-model-small-en-us-0.15.zip

mkdir /home/ovos/logs

# Fix home directory permissions
chown -R ovos:ovos /home/ovos

# Ensure executable
chmod +x /opt/ovos/*.sh
chmod +x /usr/sbin/*
chmod +x /usr/bin/*

# Install Plugins
pip3 install ovos-cli-client
pip3 install ovos-plugin-manager
pip3 install ovos-backend-client
pip3 install ovos-phal

# OCP
pip3 install ovos-plugin-common-play
pip3 install ovos-ocp-youtube-plugin
pip3 install ovos-ocp-bandcamp-plugin
pip3 install ovos-ocp-deezer-plugin
pip3 install ovos-ocp-files-plugin


# TTS
pip3 install ovos-tts-plugin-mimic
pip3 install ovos-tts-plugin-mimic2
pip3 install ovos-tts-plugin-mimic3-server
pip3 install ovos-tts-plugin-google-tx
pip3 install neon-tts-plugin-larynx_server

# WakeWords
pip3 install ovos-ww-plugin-vosk
pip3 install ovos-ww-plugin-precise
pip3 install ovos-ww-plugin-precise-lite
#ToDo: pip3 install ovos-ww-plugin-openwakeword

# STT
pip3 install ovos-stt-plugin-chromium
pip3 install ovos-stt-plugin-selene
pip3 install ovos-stt-server-plugin

mkdir -p /home/ovos/.local/share/mycroft/skills

# Install Skills
pip3 install ovos-skill-setup
pip3 install ovos-skill-homescreen
pip3 install ovos-skill-date-time
pip3 install ovos-skill-volume
pip3 install ovos-skill-stop
pip3 install skill-news
pip3 install ovos-skill-filebrowser
pip3 install neon-skill-alerts

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-weather skill-ovos-weather.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-weather.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-camera skill-camera.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-camera.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-wikipedia skill-ovos-wikipedia.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-wikipedia.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-notes skill-ovos-notes.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-notes.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-wolfie skill-ovos-wolfie.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-wolfie.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-youtube-music skill-ovos-youtube-music.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-youtube-music.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/food-wizard food-wizard.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/food-wizard.openvoiceos && pip3 install -r requirements.txt)

# Install PHAL Plugins
pip3 install ovos-PHAL-plugin-wifi-setup
pip3 install ovos-PHAL-plugin-notification-widgets
pip3 install ovos-PHAL-plugin-network-manager
pip3 install ovos-PHAL-plugin-gui-network-client
pip3 install ovos-PHAL-plugin-alsa
pip3 install ovos-PHAL-plugin-pulseaudio
pip3 install ovos-PHAL-plugin-system
pip3 install ovos-PHAL-plugin-dashboard
pip3 install ovos-PHAL-plugin-brightness-control-rpi
pip3 install ovos-PHAL-plugin-color-scheme-manager
pip3 install ovos-PHAL-plugin-configuration-provider
pip3 install ovos-PHAL-plugin-ipgeo
pip3 install ovos-PHAL-plugin-oauth
pip3 install ovos-PHAL-plugin-homeassistant
pip3 install ovos-PHAL-plugin-connectivity-events

# Missing Fixes
pip3 install fann2
pip3 install padatious
pip3 install filelock
pip3 install six
pip3 install cffi
pip3 install git+https://git.skeh.site/skeh/pyaudio
pip3 install tutubo

# Install Misc
pip3 install neon-mana-utils

# Workarounds
pip3 install ovos-skills-manager
pip3 install ovos-backend-client

# Always have these two in last to be upto date
pip3 install ovos-utils
pip3 install ovos-workshop

# Untar
(cd /usr/share/mycroft/Mimic2TTSPlugin/kusal/ && tar -xvzf en-us.tar.gz)

# Fix home directory permissions
chown -R ovos:ovos /home/ovos
chmod a=r,u+w,a+X /home/ovos

# Setup Completed
echo "OVOS Core Setup Complete"
