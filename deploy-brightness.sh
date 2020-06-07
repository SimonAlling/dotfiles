#!/usr/bin/env bash

source common.sh

TARGET_DIR='/usr/local/bin'
SCRIPT_NAME='brightness'

echo "Making ddccontrol run as root ..."
sudo chmod +s $(which ddccontrol)

echo "Installing brightness script in '${TARGET_DIR}' ..."
sudo install "${SCRIPTS_DIR}/${SCRIPT_NAME}" "${TARGET_DIR}"
