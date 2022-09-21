#!/bin/bash


build_dir=${1}
cd "${build_dir}" || exit 10

# Re-enable restart prompts
sudo mv mnt/etc/apt/apt.conf.d/.99needrestart mnt/etc/apt/apt.conf.d/99needrestart
sudo mv mnt/root/bashrc mnt/root/.bashrc
sudo rm -rf mnt/tmp/*
echo "Temporary files removed"
sudo umount mnt/run/systemd/resolve || exit 10
sudo umount mnt || exit 10
echo "Image unmounted"
#rm -r mnt