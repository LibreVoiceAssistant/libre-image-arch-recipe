#!/bin/bash

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
pip3 install https://github.com/hjonnala/snippets/blob/main/wheels/python3.10/tflite_runtime-2.5.0.post1-cp310-cp310-linux_x86_64.whl
pip3 install git+https://github.com/OpenVoiceOS/ovos-ww-plugin-precise-lite

# Install Core
pip3 install "git+https://github.com/OpenVoiceOS/ovos-core#egg=ovos_core[all]" || exit 11
echo "Core Installed"

# Download model files
mkdir -p /home/ovos/.local/share/mycroft
wget -O /home/ovos/.local/share/mycroft/vosk-model-small-en-us-0.15.zip https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip
cd /home/ovos/.local/share/mycroft || exit 10
unzip vosk-model-small-en-us-0.15.zip
rm vosk-model-small-en-us-0.15.zip

export XDG_CONFIG_HOME="/home/ovos/.config"
export XDG_DATA_HOME="/home/ovos/.local/share"
export XDG_CACHE_HOME="/home/ovos/.cache"

mkdir /home/ovos/logs

# Fix home directory permissions
chown -R ovos:ovos /home/ovos

# Ensure executable
chmod +x /opt/ovos/*.sh
chmod +x /usr/sbin/*
chmod +x /usr/bin/*

# Install Plugins
pip3 install git+https://github.com/OpenVoiceOS/ovos_cli_client
pip3 install git+https://github.com/OpenVoiceOS/OVOS-plugin-manager
pip3 install git+https://github.com/OpenVoiceOS/ovos-backend-client
pip3 install git+https://github.com/OpenVoiceOS/ovos-phal

# OCP
pip3 install git+https://github.com/OpenVoiceOS/ovos-ocp-audio-plugin

# TTS
pip3 install git+https://github.com/OpenVoiceOS/ovos-tts-plugin-google-tx
pip3 install git+https://github.com/OpenVoiceOS/ovos-tts-plugin-pico
pip3 install git+https://github.com/OpenVoiceOS/ovos-tts-plugin-mimic
pip3 install git+https://github.com/OpenVoiceOS/ovos-tts-plugin-mimic2
pip3 install git+https://github.com/OpenVoiceOS/ovos-tts-plugin-mimic3-server
pip3 install git+https://github.com/OpenVoiceOS/ovos-tts-server-plugin
pip3 install git+https://github.com/NeonGeckoCom/neon-tts-plugin-larynx_server

# WakeWords
pip3 install git+https://github.com/OpenVoiceOS/ovos-ww-plugin-precise
pip3 install git+https://github.com/OpenVoiceOS/ovos-ww-plugin-vosk

# STT
pip3 install git+https://github.com/OpenVoiceOS/ovos-stt-plugin-chromium
pip3 install git+https://github.com/OpenVoiceOS/ovos-stt-plugin-selene
pip3 install git+https://github.com/OpenVoiceOS/ovos-stt-server-plugin

mkdir -p /home/ovos/.local/share/mycroft/skills

# Install Skills
(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-setup skill-ovos-setup.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-setup.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-homescreen skill-ovos-homescreen.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-homescreen.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-weather skill-ovos-weather.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-weather.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-camera skill-camera.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-camera.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-alarm skill-ovos-alarm.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-alarm.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-timer skill-ovos-timer.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-timer.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-wikipedia skill-ovos-wikipedia.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-wikipedia.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-date-time skill-ovos-date-time.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-date-time.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-volume skill-ovos-volume.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-volume.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-stop skill-ovos-stop.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-stop.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-notes skill-ovos-notes.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-notes.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/ovos-skills-info ovos-skills-info.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/ovos-skills-info.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-wolfie skill-ovos-wolfie.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-wolfie.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/JarbasSkills/skill-youtube-music skill-youtube-music.jarbasskills)
(cd /home/ovos/.local/share/mycroft/skills/skill-youtube-music.jarbasskills && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/AIIX/food-wizard food-wizard.aiix)
(cd /home/ovos/.local/share/mycroft/skills/food-wizard.aiix && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-news skill-news.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-news.openvoiceos && pip3 install -r requirements.txt)

# Install PHAL Plugins
pip3 install https://github.com/OpenVoiceOS/ovos-PHAL-plugin-wifi-setup/archive/no/balena_and_gui_only.zip
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-notification-widgets
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-network-manager
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-gui-network-client
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-alsa
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-system
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-dashboard
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-brightness-control-rpi
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-color-scheme-manager
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-configuration-provider
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-ipgeo
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-homeassistant

# Missing Fixes
pip3 install fann2
pip3 install padatious
pip3 install filelock
pip3 install six
pip3 install cffi
pip3 install git+https://git.skeh.site/skeh/pyaudio

# Always have these two in last to be upto date
pip3 install git+https://github.com/OpenVoiceOS/ovos_utils
pip3 install git+https://github.com/OpenVoiceOS/OVOS-workshop

# Untar
(cd /usr/share/mycroft/Mimic2TTSPlugin/kusal/ && tar -xvzf en-us.tar.gz)

# Setup Completed
echo "OVOS Core Setup Complete"
