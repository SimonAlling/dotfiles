#!/bin/sh

# The only way to set a fan speed below 40 % on my Gigabyte RTX 2060 Super card is to start at 40 % and carefully decrease it from there.
STEPS="40 30 25"
# The speed must be given time to stabilize before being changed again; otherwise the fans enter WOOSH WOOSH mode. Stabilization takes about 5 seconds.
STEP_INTERVAL=7

set -e

for speed in $STEPS; do
    nvidia-settings -a "[gpu:0]/GPUFanControlState=1" -a "[fan:0]/GPUTargetFanSpeed=$speed"
    sleep $STEP_INTERVAL
done &
