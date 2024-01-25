#!/usr/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/menu_standard.sh"
host="$(cat /etc/hostname)"

menu_theme_setup "launcher"

app_cmd "run applications"