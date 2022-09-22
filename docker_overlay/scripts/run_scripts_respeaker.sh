#!/bin/bash


# Set to exit on error
set -Ee

cd /tmp || exit 10
source vars.sh

print_opts() {
    clear
    echo ""
    echo "------------------"
    echo "OVOS Image Creator"
    echo "------------------"
    echo "0. Exit"
    echo "1. Core Configuration"
    echo "2. Network Manager"
    echo "3. Respeaker"
    echo "4. Embedded Shell + GUI"
    echo "5. OVOS Core"
    echo "6. Dashboard"
    echo "7. Camera"
    echo "8. Splash Screen"
}

get_choice() {
    read -p "Select Option " opt
    case ${opt} in
        0) exit 0;;
        1) bash /tmp/01_core_configuration/configure_arch.sh;;
        2) bash /tmp/02_network_manager/setup_wifi_connect.sh;;
        3) bash /tmp/03_respeaker/setup_respeaker.sh;;
        4) bash /tmp/04_embedded_shell/install_gui_shell.sh;;
        5) bash /tmp/05_ovos_core/install_requirements.sh;;
        6) bash /tmp/06_dashboard/install_ovos_dashboard.sh;;
        7) bash /tmp/07_camera/configure_camera.sh;;
        8) bash /tmp/08_splash_screen/configure_splash.sh;;
        9) bash /tmp/09_mycroft_services/install_ovos_services.sh;;
        *) ;;
    esac
}

if [ ${1} == "all" ]; then
    bash /tmp/01_core_configuration/configure_arch.sh
    bash /tmp/02_network_manager/setup_wifi_connect.sh
    bash /tmp/03_respeaker/setup_respeaker.sh
    bash /tmp/04_embedded_shell/install_gui_shell.sh
    bash /tmp/05_ovos_core/install_requirements.sh
    bash /tmp/06_dashboard/install_ovos_dashboard.sh
    bash /tmp/07_camera/configure_camera.sh
    bash /tmp/08_splash_screen/configure_splash.sh
    bash /tmp/09_mycroft_services/install_ovos_services.sh
    exit 0
fi

while true; do
    print_opts
    get_choice
done
