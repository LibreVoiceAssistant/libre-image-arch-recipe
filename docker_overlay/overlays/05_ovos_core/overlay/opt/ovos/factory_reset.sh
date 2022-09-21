#!/usr/bin/env bash
sudo rm -rf /home/ovos/.ovos
sudo rm -rf /home/ovos/ovos
#sudo rm -rf /etc/ovos
sudo rm -rf /var/log/ovos
sudo mkdir -p /var/log/ovos
mkdir -p /home/ovos/ovos /home/ovos/.ovos /tmp/ovos
chown 1000:1000 /home/ovos/ovos /home/ovos/.ovos /tmp/ovos /var/log/ovos
