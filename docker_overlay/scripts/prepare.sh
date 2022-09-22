#!/bin/bash


# Set to exit on error
set -Ee

image_file=${1}
build_dir=${2}

if [ -z "${image_file}" ]; then
    echo "No file specified to mount"
    exit 2
fi

BASE_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
recipe_dir="/overlays"
cd "${build_dir}" || exit 10

# mkdir boot
# mkdir mnt

mkdir mnt

loop=$(sudo losetup -fP --show "${image_file}")
echo "Display loop info"
echo ${loop}
sleep 3
boot_part="${loop}p1"
root_part="${loop}p2"
sudo mount "${boot_part}" mnt/boot/
sudo mount "${root_part}" mnt

echo "Mounted Image FS"
echo "------------------------------------"
echo "Copying Boot Overlay Files"
# Manjaro Minimal=32000000
#sudo mount -o loop,offset=32000000 "${image_file}" boot || exit 10

if [ "${4}" == "respeaker" ]; then
    echo "Selected respeaker boot overlay"
    sudo cp -r ${recipe_dir}/00_boot_overlay_respeaker/overlays/* mnt/boot/overlays/
    sudo cp -r ${recipe_dir}/00_boot_overlay_respeaker/config.txt mnt/boot/config.txt
fi
if [ "${4}" == "mark2" ]; then
    echo "Selected mark2 boot overlay"
    sudo cp -r ${recipe_dir}/00_boot_overlay_mark2/overlays/* mnt/boot/overlays/
    sudo cp -r ${recipe_dir}/00_boot_overlay_mark2/config.txt mnt/boot/config.txt
fi
sleep 1  # Avoid busy target issues

#sudo umount boot
#rm -r boot
echo "Boot Files Configured"

# Backup original resolv
if [ -f mnt/etc/resolv.conf ]; then
    sudo mv mnt/etc/resolv.conf mnt/etc/.resolv.conf
fi

echo "Mounting Image FS"
# Manjaro Minimal=512000512
# sudo mount -o loop,offset=512000512 "${image_file}" mnt && echo "Mounted root image FS" || exit 10
ls mnt
ls mnt/boot/
sudo mkdir -p mnt/run/systemd/resolve
sudo mount --bind /run/systemd/resolve mnt/run/systemd/resolve  && echo "Mounted resolve directory from host" || exit 10
sudo mount --bind /etc/resolv.conf mnt/etc/resolv.conf
sudo mount -t sysfs sys mnt/sys
sudo mount -t proc proc mnt/proc
sudo mount -o bind /dev mnt/dev

echo "Writing Build Info to Image"
sudo mkdir -p mnt/opt/ovos

echo "Copying Image scripts"
cp -r "${recipe_dir}/01_core_configuration" mnt/tmp/
cp -r "${recipe_dir}/02_network_manager" mnt/tmp/
cp -r "${recipe_dir}/04_embedded_shell" mnt/tmp/
cp -r "${recipe_dir}/05_ovos_core" mnt/tmp/
cp -r "${recipe_dir}/06_dashboard" mnt/tmp/
cp -r "${recipe_dir}/07_camera" mnt/tmp/
cp -r "${recipe_dir}/08_splash_screen" mnt/tmp/
cp -r "${recipe_dir}/09_mycroft_services" mnt/tmp/

# Copy variables into base image
echo "export CORE_REF=${CORE_REF:-dev}" > mnt/tmp/vars.sh
echo "export MAKE_THREADS=${MAKE_THREADS:-4}" >> mnt/tmp/vars.sh

if [ "${4}" == "respeaker" ]; then
    echo "export IMAGE_BUILD_TYPE=${4}" >> mnt/tmp/vars.sh
    cp "/scripts/run_scripts_respeaker.sh" mnt/tmp
    cp -r "${recipe_dir}/03_respeaker" mnt/tmp/
    cp -r "${recipe_dir}/10_fix_boot_respeaker" mnt/tmp/
fi

if [ "${4}" == "mark2" ]; then
    echo "export IMAGE_BUILD_TYPE=${4}" >> mnt/tmp/vars.sh
    cp "/scripts/run_scripts_mark2.sh" mnt/tmp
    cp -r "${recipe_dir}/03_sj201" mnt/tmp/
    cp -r "${recipe_dir}/10_fix_boot_mark2" mnt/tmp/
fi

# # Configure bashrc so script runs on login (chroot)
if [ "${3}" == "-y" ]; then
     echo "Configuring script to run on chroot"
     if [ "${4}" == "respeaker" ]; then
        sudo cp "/scripts/bashrc-respeaker" mnt/root/.bashrc
     fi
     if [ "${4}" == "mark2" ]; then
        sudo cp "/scripts/bashrc-mark2" mnt/root/.bashrc
     fi
fi

sudo cp "/scripts/bashrc-cleanup" mnt/tmp/
sudo cp "/scripts/cli_login.sh" mnt/tmp/

sudo chroot mnt
