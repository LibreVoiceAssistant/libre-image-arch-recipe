#!/bin/bash


build_dir=${1}
cd "${build_dir}" || exit 10

# Re-enable restart prompts
sudo mv mnt/tmp/bashrc-cleanup mnt/root/.bashrc
sudo mv mnt/tmp/cli_login.sh mnt/root/cli_login.sh
sudo rm -rf mnt/tmp/*
echo "Temporary files removed"
sudo umount mnt/run/systemd/resolve || exit 10
sudo umount mnt/etc/resolv.conf || exit 10
sudo umount mnt/sys || exit 10
sudo umount mnt/proc || exit 10
sudo umount mnt/dev || exit 10
sudo umount mnt || exit 10
echo "Image unmounted"
#rm -r mnt
