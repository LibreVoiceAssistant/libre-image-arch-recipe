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

mkdir mnt

echo "Mounting Image FS"
#Manjaro Minimal=512000512
sudo mount -o loop,offset=512000512,sizelimit=8305475072 "${image_file}" mnt && echo "Mounted root image FS" || exit 10
sudo mkdir -p mnt/run/systemd/resolve
sudo mount --bind /run/systemd/resolve mnt/run/systemd/resolve  && echo "Mounted resolve directory from host" || exit 10
sudo mount --bind /etc/resolv.conf mnt/etc/resolv.conf

sleep 3

sudo mount -o loop,offset=32000000,sizelimit=480000512 "${image_file}" mnt/boot/ || exit 10

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
sleep 2
echo "Boot Files Configured"

# ls mnt
# ls mnt/boot/
# ls mnt/etc/

echo "Writing Build Info to Image"
sudo mkdir -p mnt/opt/ovos
sudo mkdir -p mnt/opt/ovos/install/

echo "Copying Image scripts"
cp -r "${recipe_dir}/pass.txt" mnt/opt/ovos/install/
cp -r "${recipe_dir}/01_core_configuration" mnt/opt/ovos/install/
cp -r "${recipe_dir}/02_network_manager" mnt/opt/ovos/install/
cp -r "${recipe_dir}/04_embedded_shell" mnt/opt/ovos/install/
cp -r "${recipe_dir}/05_ovos_core" mnt/opt/ovos/install/
cp -r "${recipe_dir}/06_dashboard" mnt/opt/ovos/install/
cp -r "${recipe_dir}/07_camera" mnt/opt/ovos/install/
cp -r "${recipe_dir}/08_splash_screen" mnt/opt/ovos/install/
cp -r "${recipe_dir}/09_mycroft_services" mnt/opt/ovos/install/

# Copy variables into base image
echo "export CORE_REF=${CORE_REF:-dev}" > mnt/opt/ovos/install/vars.sh
echo "export MAKE_THREADS=${MAKE_THREADS:-4}" >> mnt/opt/ovos/install/vars.sh

if [ "${4}" == "respeaker" ]; then
    echo "export IMAGE_BUILD_TYPE=${4}" >> mnt/opt/ovos/install/vars.sh
    cp "/scripts/run_scripts_respeaker.sh" mnt/opt/ovos/install/
    cp "/scripts/run_scripts_respeaker.sh" mnt/usr/bin/
    chmod 777 mnt/usr/bin/run_scripts_respeaker.sh
    cp -r "${recipe_dir}/03_respeaker" mnt/opt/ovos/install/
    cp -r "${recipe_dir}/10_fix_boot_respeaker" mnt/opt/ovos/install/
fi

if [ "${4}" == "mark2" ]; then
    echo "export IMAGE_BUILD_TYPE=${4}" >> mnt/opt/ovos/install/vars.sh
    cp "/scripts/run_scripts_mark2.sh" mnt/opt/ovos/install/
    cp "/scripts/run_scripts_mark2.sh" mnt/usr/bin/
    chmod 777 mnt/usr/bin/run_scripts_mark2.sh
    cp -r "${recipe_dir}/03_sj201" mnt/opt/ovos/install/
    cp -r "${recipe_dir}/10_fix_boot_mark2" mnt/opt/ovos/install/
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

sudo cp "/scripts/bashrc-cleanup" mnt/opt/ovos/install/
sudo cp "/scripts/cli_login.sh" mnt/opt/ovos/install/

if [ "${4}" == "respeaker" ]; then
    sudo manjaro-chroot mnt /bin/run_scripts_respeaker.sh
fi

if [ "${4}" == "mark2" ]; then
    sudo manjaro-chroot mnt /bin/run_scripts_mark2.sh
fi
