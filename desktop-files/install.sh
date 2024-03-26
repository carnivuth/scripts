#!/bin/bash
source "$HOME/scripts/settings.sh"

# copy config files
echo 'coping desktop files'
mkdir -p "$HOME/.local/share/applications/"
ln -fs  "$SCRIPTS_HOME_FOLDER/desktop-files/"*.desktop "$HOME/.local/share/applications/"
