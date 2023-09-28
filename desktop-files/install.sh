#!/bin/bash
source "$HOME/scripts/settings.sh"

# copy config files
echo 'coping desktop files'
cp -r "$SCRIPTS_HOME_FOLDER/desktop-files/"* "$HOME/.local/share/applications/"
