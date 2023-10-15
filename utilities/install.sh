#!/bin/bash
source "$HOME/scripts/settings.sh"

# copy config files
echo 'installing utils'
if [[ "$(echo $PATH | grep "$SCRIPTS_HOME_FOLDER/utilities/")" == "" ]]; then
    echo "export PATH=$SCRIPTS_HOME_FOLDER/utilities/:$PATH" >>"$HOME/.bashrc"
    export PATH="$SCRIPTS_HOME_FOLDER/utilities/:$PATH"
fi
