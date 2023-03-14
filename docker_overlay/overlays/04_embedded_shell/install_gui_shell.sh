#!/bin/bash

BASE_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BASE_DIR}" || exit 10

# Install gui base dependencies
pacman --noconfirm -Syyuu
pacman --noconfirm -Syu cmake extra-cmake-modules kio kio-extras plasma-framework kirigami2 kirigami-addons qt5-websockets qt5-webview qt5-declarative qt5-multimedia qt5-quickcontrols2 qt5-webengine qt5-base qt5-virtualkeyboard qt5-location qt5-graphicaleffects qt5-networkauth qt5-svg qt5-tools qt5-xmlpatterns qt5-script libpulse plasma-nm plasma-pa qt5ct gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-plugin-va libva libva-utils ffmpeg qmltermwidget qtav kdeconnect

# Install embedded-shell
git clone https://github.com/OpenVoiceOS/ovos-shell

cd ovos-shell || exit 10
cmake .
bash prefix.sh
make ovos-shell
make install ovos-shell || exit 10
cd "${BASE_DIR}" || exit 10
rm -rf ovos-shell

# Install GUI
wget https://github.com/MycroftAI/mycroft-gui/archive/refs/tags/stable-qt5.tar.gz
tar -xvf stable-qt5.tar.gz

#bash mycroft-gui/dev_setup.sh
cd mycroft-gui-stable-qt5 || exit 10
TOP=$( pwd -L )

echo "Building Mycroft GUI"
if [[ ! -d build-testing ]] ; then
  mkdir build-testing
fi
cd build-testing || exit 10
cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DKDE_INSTALL_LIBDIR=lib -DKDE_INSTALL_USE_QT_SYS_PATHS=ON
make -j${MAKE_THREADS}
make install

echo "Installing Lottie-QML"
cd "$TOP" || exit 10
if [[ ! -d lottie-qml ]] ; then
    git clone https://github.com/kbroulik/lottie-qml
    cd lottie-qml || exit 10
    mkdir build
else
    cd lottie-qml || exit 10
    git pull
fi

cd build || exit 10
cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DKDE_INSTALL_LIBDIR=lib -DKDE_INSTALL_USE_QT_SYS_PATHS=ON
make
make install

cd "${BASE_DIR}" || exit 10
rm -rf mycroft-gui

# Copy overlay files and enable gui service
cp -r overlay/* /
chmod -R ugo+x /usr/bin
chown -R ovos:ovos /home/ovos

echo "GUI Embedded Shell Configured"
