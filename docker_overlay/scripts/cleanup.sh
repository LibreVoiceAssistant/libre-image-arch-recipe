#!/bin/bash


build_dir=${1}
cd "${build_dir}" || exit 10

lsof mnt
sudo umount mnt/etc/resolv.conf || exit 10

if [ -f mnt/etc/.resolv.conf ]; then
    sudo mv mnt/etc/.resolv.conf mnt/etc/resolv.conf
fi

# Re-enable restart prompts
sudo mv mnt/opt/ovos/install/bashrc-cleanup mnt/root/.bashrc
sudo mv mnt/opt/ovos/install/cli_login.sh mnt/root/cli_login.sh
sudo rm -rf mnt/tmp/*
echo "Temporary files removed"
sudo umount mnt/boot || exit 10
sudo umount mnt/run/systemd/resolve || exit 10
echo "Image unmounted"
