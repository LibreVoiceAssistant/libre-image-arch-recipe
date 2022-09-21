#!/bin/bash

growpart /dev/sda 2
resize2fs /dev/sda2
rm /opt/ovos/resize_fs