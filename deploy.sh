#!/usr/bin/env bash

readonly REAL_RC_FILE="$HOME/.bashrc"
readonly CONFIG_FILE=".shellrc" # must not contain spaces
readonly REAL_RC_FILE_ADDITION=". ~/$CONFIG_FILE"
readonly GITCONFIG=".gitconfig"

# Deploy files
cp "$CONFIG_FILE" ~
cp "$GITCONFIG" ~

# Configure shell
if [[ -f "$REAL_RC_FILE" ]]; then
    if [[ -z $(grep -Fx "$REAL_RC_FILE_ADDITION" "$REAL_RC_FILE") ]]; then
        echo "Modifying '$REAL_RC_FILE'..."
        echo "$REAL_RC_FILE_ADDITION" >> "$REAL_RC_FILE"
    else
        echo "'$REAL_RC_FILE' exists, but has already been modified."
    fi
fi
