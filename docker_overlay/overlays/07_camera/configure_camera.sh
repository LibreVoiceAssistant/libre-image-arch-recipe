#!/bin/bash


BASE_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BASE_DIR}" || exit 10

# Install build dependencies
pacman --noconfirm -Syyuu
pacman --noconfirm -Syu boost gnutls lttng-ust meson ninja openssl python-jinja python-ply python-yaml sed gtest doxygen graphviz libevent libtiff python-sphinx

# Clone and build libcamera
git clone https://github.com/raspberrypi/libcamera.git
cd libcamera || exit 10
meson build --buildtype=release -Dpipelines=raspberrypi -Dipas=raspberrypi -Dv4l2=true -Dtest=false -Dlc-compliance=disabled -Dcam=disabled -Dqcam=disabled -Ddocumentation=disabled
ninja -C build install
cd ..
rm -rf libcamera

# Clone and build libepoxy
git clone https://github.com/anholt/libepoxy.git
cd libepoxy || exit 10
mkdir _build
cd _build || exit 10
meson
ninja
ninja install
cd ../..
rm -rf libepoxy

# Clone and build libcamera-apps
git clone https://github.com/raspberrypi/libcamera-apps.git
cd libcamera-apps || exit 10
mkdir build
cd build || exit 10
cmake .. -DENABLE_DRM=1 -DENABLE_X11=0 -DENABLE_QT=1 -DENABLE_OPENCV=0 -DENABLE_TFLITE=0
make install

echo "Camera dependencies installed"
