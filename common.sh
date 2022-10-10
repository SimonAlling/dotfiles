set -euo pipefail

DESKTOP_ENTRIES_SOURCE="desktop-entries"
DESKTOP_ENTRIES_TARGET="/usr/share/applications"
SCRIPTS_DIR='scripts'
PROFILE_SCRIPTS_DIR='/etc/profile.d'
BIN_DIR='/usr/bin'

RESET="\e[0m"
BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[32m"
