#!/usr/bin/env bash

set -e

sudo apt install -y dkms
sudo cp hid_apple.conf /etc/modprobe.d

cd ..
cd hid-apple-patched && {
    git checkout master
    git pull
} || {
    git clone https://github.com/free5lot/hid-apple-patched
    cd hid-apple-patched
}

# "You cannot add the same module/version combo more than once."
if [ -z "$(sudo dkms status hid-apple)" ]; then
    sudo dkms add .
fi

sudo dkms build hid-apple/1.0
sudo dkms install hid-apple/1.0
sudo update-initramfs -u
sudo modprobe -r hid_apple; sudo modprobe hid_apple
