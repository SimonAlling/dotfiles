#!/usr/bin/env bash

source common.sh

readonly REAL_RC_FILE="$HOME/.bashrc"
readonly CONFIG_FILE=".shellrc" # must not contain spaces
readonly REAL_RC_FILE_ADDITION=". ~/$CONFIG_FILE"
declare -a FILES_TO_COPY_TO_HOME=(
    "$CONFIG_FILE"
    ".config"
    ".gitconfig"
    ".gitignore"
    ".vimrc"
)

# Deploy files
for f in "${FILES_TO_COPY_TO_HOME[@]}"; do
    echo "Copying ${f} to home directory..."
    cp -R "$f" "$HOME"
done

# Create Vim undo dir
mkdir -p $HOME/.vimundo

# Configure shell
if [[ -f "$REAL_RC_FILE" ]]; then
    if [[ -z $(grep -Fx "$REAL_RC_FILE_ADDITION" "$REAL_RC_FILE") ]]; then
        echo "Modifying '$REAL_RC_FILE'..."
        echo "$REAL_RC_FILE_ADDITION" >> "$REAL_RC_FILE"
    else
        echo "'$REAL_RC_FILE' exists, but has already been modified."
    fi
fi
