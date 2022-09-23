#!/bin/bash


# Set to exit on error
set -Ee

cd /opt/ovos/install || exit 10
source vars.sh

echo ""
echo "------------------"
echo "OVOS Image Creator"
echo "------------------"

bash /opt/ovos/install/01_core_configuration/configure_arch.sh
bash /opt/ovos/install/02_network_manager/setup_wifi_connect.sh
bash /opt/ovos/install/03_sj201/setup_sj201.sh
bash /opt/ovos/install/04_embedded_shell/install_gui_shell.sh
bash /opt/ovos/install/05_ovos_core/install_requirements.sh
bash /opt/ovos/install/06_dashboard/install_ovos_dashboard.sh
bash /opt/ovos/install/07_camera/configure_camera.sh
bash /opt/ovos/install/08_splash_screen/configure_splash.sh
bash /opt/ovos/install/09_mycroft_services/install_ovos_services.sh
bash /opt/ovos/install/10_fix_boot_mark2/fix_ovos_mark2_boot.sh
exit 0
