#!/usr/bin/env bash

source common.sh

TARGET_DIR='/usr/local/bin'
SCRIPT_NAME='brightness'
DDC_TOOL=ddcutil

echo "Making ${DDC_TOOL} run as root ..."
sudo chmod +s $(which ${DDC_TOOL})

echo "Installing brightness script in '${TARGET_DIR}' ..."
sudo install "${SCRIPTS_DIR}/${SCRIPT_NAME}" "${TARGET_DIR}"
