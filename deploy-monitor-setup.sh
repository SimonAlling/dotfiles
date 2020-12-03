#!/usr/bin/env bash

source common.sh

TARGET_DIR="${PROFILE_SCRIPTS_DIR}"
SCRIPT_NAME='monitor-setup/default.sh'
SCRIPT_NAME_IN_TARGET_DIR='monitor-setup.sh'

echo "Copying monitor setup script to '${TARGET_DIR}' ..."
sudo cp "${SCRIPTS_DIR}/${SCRIPT_NAME}" "${TARGET_DIR}/${SCRIPT_NAME_IN_TARGET_DIR}"

for script in "${SCRIPTS_DIR}"/monitor-setup/*; do
    executable_name=$(basename "$script" ".sh")
    echo "Copying $script to '${BIN_DIR}/${executable_name}' ..."
    sudo cp "$script" "${BIN_DIR}/${executable_name}"
done

echo "Done. Monitor setup should be automatically applied on next login."
