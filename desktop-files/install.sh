#!/bin/bash
source "$HOME/scripts/settings.sh"

# copy config files
echo 'coping desktop files'
mkdir -p "$HOME/.local/share/applications/"
cp -r "$SCRIPTS_HOME_FOLDER/desktop-files/"* "$HOME/.local/share/applications/"
