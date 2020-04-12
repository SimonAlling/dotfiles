#!/usr/bin/env bash

SCRIPTS_DIR='scripts'
TARGET_DIR='/etc/profile.d'
SCRIPT_NAME='set-gpu-fan-speed.sh'
COOL_BITS=31 # https://wiki.archlinux.org/index.php/NVIDIA/Tips_and_tricks#Enabling_overclocking

set -e

echo "Unlocking Nvidia settings ..."
sudo nvidia-xconfig -a --cool-bits=${COOL_BITS} --allow-empty-initial-configuration

echo "Copying fan speed script to '${TARGET_DIR}' ..."
sudo cp -t "${TARGET_DIR}" "${SCRIPTS_DIR}/${SCRIPT_NAME}"
sudo chmod 644 "${TARGET_DIR}/${SCRIPT_NAME}"

echo "Done. Fan speed should be automatically set on next login."
