#!/bin/bash


BASE_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BASE_DIR}" || exit 10
cp -rf overlay/* / || exit 2

cd /usr/local/share || exit 10
git clone https://github.com/openvoiceos/ovos-dashboard
pip install -r ovos-dashboard/requirements.txt

# Make sure installed packages are properly owned
chown -R ovos:ovos /home/ovos

echo "OVOS Dashboard installed"
