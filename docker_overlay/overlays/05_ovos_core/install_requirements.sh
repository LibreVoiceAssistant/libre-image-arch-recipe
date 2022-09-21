#!/bin/bash


BASE_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BASE_DIR}" || exit 10

# install system packages
pacman --noconfirm -Syyuu
pacman --noconfirm -Syu python-setuptools python python-gobject libffi swig portaudio mimic mpg123 screen flac curl icu libjpeg-turbo jq pulseaudio pulseaudio-alsa fann sox python-pip python-virtualenv

# Copy overlay files (default configuration)
cd "${BASE_DIR}" || exit 10
cp -rf overlay/* / || exit 2
cd /home/ovos || exit 2

# Lets try the tflite stuff in 3.10
pip3 install wheel
pip3 install https://github.com/PINTO0309/TensorflowLite-bin/releases/download/v2.10.0/tflite_runtime-2.10.0-cp310-none-linux_aarch64.whl
pip3 install https://github.com/OpenVoiceOS/ovos-ww-plugin-precise-lite

# Install Core
pip3 install "git+https://github.com/OpenVoiceOS/ovos-core@${CORE_REF:-dev}#egg=ovos_core[all]" || exit 11
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


# Relocate any cached data to the `ovos` user
#rm -r /root/.cache/pip
#mkdir -p /home/ovos/.cache
#cp -rf /root/.cache/* /home/ovos/.cache/
#rm -r /root/.cache

mkdir /home/ovos/logs

# Fix home directory permissions
chown -R ovos:ovos /home/ovos

# Ensure executable
chmod +x /opt/ovos/*.sh
chmod +x /usr/sbin/*
chmod +x /usr/bin/*

# Install Plugins
pip3 install git+https://github.com/OpenVoiceOS/ovos-ocp-audio-plugin
pip3 install git+https://github.com/OpenVoiceOS/ovos-ww-plugin-vosk
pip3 install git+https://github.com/OpenVoiceOS/ovos_cli_client
pip3 install git+https://github.com/OpenVoiceOS/ovos-tts-plugin-google-tx
pip3 install git+https://github.com/OpenVoiceOS/ovos-tts-plugin-pico
pip3 install git+https://github.com/OpenVoiceOS/ovos-tts-plugin-mimic3
pip3 install git+https://github.com/OpenVoiceOS/ovos-tts-plugin-mimic2
pip3 install git+https://github.com/OpenVoiceOS/ovos-tts-plugin-mimic
pip3 install git+https://github.com/OpenVoiceOS/ovos-stt-plugin-chromium
pip3 install git+https://github.com/OpenVoiceOS/ovos-stt-plugin-selene
pip3 install git+https://github.com/OpenVoiceOS/ovos-stt-plugin-pocketsphinx
pip3 install git+https://github.com/OpenVoiceOS/ovos-stt-server-plugin
pip3 install git+https://github.com/OpenVoiceOS/ovos-ww-plugin-precise
pip3 install git+https://github.com/OpenVoiceOS/ovos-intent-plugin-padatious
pip3 install git+https://github.com/OpenVoiceOS/OVOS-plugin-manager

# Install Skills
(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-setup skill-ovos-setup.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-setup.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-homescreen skill-ovos-homescreen.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-homescreen.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-weather skill-ovos-weather.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-weather.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-camera skill-camera.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-camera.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-camera skill-camera.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-camera.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-alarm skill-ovos-alarm.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-alarm.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-timer skill-ovos-timer.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-timer.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-wikipedia-for-humans skill-wikipedia-for-humans.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-wikipedia-for-humans.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-date-time skill-date-time.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-date-time.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-volume skill-ovos-volume.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-volume.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-stop skill-ovos-stop.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-stop.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-ovos-notes skill-ovos-notes.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-ovos-notes.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/ovos-skills-info ovos-skills-info.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/ovos-skills-info.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-wolfie skill-wolfie.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-wolfie.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-wikipedia-for-humans skill-wikipedia-for-humans.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-wikipedia-for-humans.openvoiceos && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/JarbasSkills/skill-youtube-music skill-youtube-music.jarbasskills)
(cd /home/ovos/.local/share/mycroft/skills/skill-youtube-music.jarbasskills && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/AIIX/food-wizard food-wizard.aiix)
(cd /home/ovos/.local/share/mycroft/skills/food-wizard.aiix && pip3 install -r requirements.txt)

(cd /home/ovos/.local/share/mycroft/skills && git clone https://github.com/OpenVoiceOS/skill-news skill-news.openvoiceos)
(cd /home/ovos/.local/share/mycroft/skills/skill-news.openvoiceos && pip3 install -r requirements.txt)

# Install PHAL Plugins
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-notification-widgets
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-network-manager
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-gui-network-client
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-mk2
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-wifi-setup
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-balena-wifi
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-alsa
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-system
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-dashboard
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-brightness-control-rpi
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-color-scheme-manager
pip3 install git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-configuration-provider

# Missing Fixes
pip3 install filelock
pip3 install six
pip3 install cffi
pip install git+https://git.skeh.site/skeh/pyaudio

# Just incase
pip3 install git+https://github.com/OpenVoiceOS/ovos_utils
pip3 install git+https://github.com/OpenVoiceOS/OVOS-workshop

# Untar
(cd /usr/share/mycroft/Mimic2TTSPlugin/kusal/ && tar -xvzf en-us.tar.gz)

# Setup Completed
echo "OVOS Core Setup Complete"
