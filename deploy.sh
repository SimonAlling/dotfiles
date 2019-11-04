#!/usr/bin/env bash

readonly CONFIG_FILE=".shellrc" # must not contain spaces
readonly GITCONFIG=".gitconfig"

# Deploy files
cp "$CONFIG_FILE" ~
cp "$GITCONFIG" ~

# Configure Bash
if [ -f ~/.bashrc ]; then
    echo ". ~/$CONFIG_FILE" >> ~/.bashrc
fi
