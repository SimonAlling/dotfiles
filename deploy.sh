#!/usr/bin/env bash

readonly CONFIG_FILE=".shellrc" # must not contain spaces

# Deploy files
cp "$CONFIG_FILE" ~

# Configure Bash
if [ -f ~/.bashrc ]; then
    echo ". ~/$CONFIG_FILE" >> ~/.bashrc
fi

