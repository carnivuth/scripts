#!/bin/bash
source "$HOME/scripts/settings.sh"

# copy config files
echo 'installing utils'
export PATH="$SCRIPTS_HOME_FOLDER/utilities/:$PATH"
echo "export PATH=$SCRIPTS_HOME_FOLDER/utilities/:$PATH" >> "$HOME/.bashrc"