#!/bin/bash
source "$HOME/scripts/settings.sh"

# copy config files
echo 'coping desktop files'
mkdir -p "$HOME/.local/share/applications/"
ln -s  "$SCRIPTS_HOME_FOLDER/desktop-files/"* "$HOME/.local/share/applications/"
