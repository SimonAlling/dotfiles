#!/usr/bin/env bash

source common.sh

function isWorkMode() {
    [[ "${WORK:-}" == 'true' ]]
}

echo -n "Work mode: "; isWorkMode && echo -e "${BOLD}${GREEN}YES${RESET}" || echo -e "${BOLD}${RED}NO${RESET}"

readonly REAL_RC_FILE="$HOME/.bashrc"
readonly CONFIG_FILE=".shellrc" # must not contain spaces
readonly CONFIG_FILE_WORK=".shellrc.work" # must not contain spaces
declare -a FILES_TO_COPY_TO_HOME=(
    "$CONFIG_FILE"
    ".config"
    ".gitconfig"
    ".gitignore"
    ".npmrc"
    ".vimrc"
)
isWorkMode && FILES_TO_COPY_TO_HOME+=("$CONFIG_FILE_WORK")

# Deploy files
for f in "${FILES_TO_COPY_TO_HOME[@]}"; do
    echo "Copying ${f} to home directory..."
    cp -R "$f" "$HOME"
done

# Create Vim undo dir
mkdir -p $HOME/.vimundo

# Configure shell
function addToRealRcFile() {
    addition="$1"
    if [[ -f "$REAL_RC_FILE" ]]; then
        if [[ -z $(grep -Fx "$addition" "$REAL_RC_FILE") ]]; then
            echo "Modifying '$REAL_RC_FILE'..."
            echo "$addition" >> "$REAL_RC_FILE"
        else
            echo "'$REAL_RC_FILE' exists, but already contains '$addition'."
        fi
    fi
}
addToRealRcFile ". ~/$CONFIG_FILE"
isWorkMode && addToRealRcFile ". ~/$CONFIG_FILE_WORK"
