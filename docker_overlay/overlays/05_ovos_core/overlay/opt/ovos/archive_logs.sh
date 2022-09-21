#!/bin/bash

boot_time=$(date +'%Y-%m-%d_%H-%M')
cd /home/ovos/logs || exit 2
mkdir "${boot_time}"
mv -f ./*.log "${boot_time}/" || rm -r "${boot_time}"