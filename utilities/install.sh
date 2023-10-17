#!/bin/bash
source "$HOME/scripts/settings.sh"

# install packages
echo 'installing packages'
packets='at'
sudo pacman -S $packets

# copy config files
echo 'installing utils'
if [[ "$(cat $HOME/.bashrc | grep $SCRIPTS_HOME_FOLDER/utilities/)" == "" ]]; then
    echo "export PATH=$SCRIPTS_HOME_FOLDER/utilities/:$PATH" >>"$HOME/.bashrc"
    export PATH="$SCRIPTS_HOME_FOLDER/utilities/:$PATH"
fi

# enabling at daemon
echo 'enabling at daemon'
sudo systemctl enable --now atd
