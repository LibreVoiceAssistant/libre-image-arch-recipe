#!/bin/bash

ip route | grep default

if [ $? != 0 ]; then
    if [ -n "$(ls /etc/NetworkManager/system-connections/)" ]; then
        echo "Network Configured, waiting for reconnection"
        sleep 15
        ip route | grep default
    else
        echo "No Networks Configured"
    fi
fi
if [ $? != 0 ]; then
    echo "Network not connected, starting wifi-connect"
    wifi-connect  --portal-ssid OVOS
fi
