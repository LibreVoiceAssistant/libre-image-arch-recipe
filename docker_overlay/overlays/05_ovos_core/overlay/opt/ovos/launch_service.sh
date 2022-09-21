#!/bin/bash

source /home/ovos/venv/bin/activate
killall ${1}
echo ">>>Starting ${1}<<<"
${1}