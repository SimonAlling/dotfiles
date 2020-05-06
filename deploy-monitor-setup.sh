#!/usr/bin/env bash

SCRIPTS_DIR='scripts'
TARGET_DIR='/etc/profile.d'
SCRIPT_NAME='monitor-setup/default.sh'
SCRIPT_NAME_IN_TARGET_DIR='monitor-setup.sh'

echo "Copying monitor setup script to '${TARGET_DIR}' ..."
sudo cp "${SCRIPTS_DIR}/${SCRIPT_NAME}" "${TARGET_DIR}/${SCRIPT_NAME_IN_TARGET_DIR}"

echo "Done. Monitor setup should be automatically applied on next login."
