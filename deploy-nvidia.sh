#!/usr/bin/env bash

source common.sh

COOL_BITS=31 # https://wiki.archlinux.org/index.php/NVIDIA/Tips_and_tricks#Enabling_overclocking

set -e

# Deploy VS Code desktop entry with fix for black screen on launch (--disable-gpu):
echo "Copying VS Code desktop entry to ${DESKTOP_ENTRIES}..."
sudo cp ${DESKTOP_ENTRIES_SOURCE}/nvidia/code.desktop ${DESKTOP_ENTRIES_TARGET}

echo "Unlocking Nvidia settings ..."
sudo nvidia-xconfig -a --cool-bits=${COOL_BITS} --allow-empty-initial-configuration
