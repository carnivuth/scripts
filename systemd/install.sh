#!/bin/bash
source "$HOME/scripts/settings.sh"

# install packages
echo 'installing packages'
packets='borg upower jq rclone'
sudo pacman -S $packets

# installing services
if [[ -d "$SCRIPTS_HOME_FOLDER"/systemd/user/services/ ]]; then
    echo 'installing user services'
    sudo cp "$SCRIPTS_HOME_FOLDER"/systemd/user/services/* "/etc/systemd/user/"
    for servicefile in "$SCRIPTS_HOME_FOLDER/systemd/user/services/"*; do
        service=$(echo $servicefile | rev | cut -d'/' -f 1 | rev)
        echo $service
        systemctl --user enable --now $service
    done
fi
if [[ -d "$SCRIPTS_HOME_FOLDER"/systemd/user/timers/ ]]; then
    echo 'installing user timers'
    sudo cp "$SCRIPTS_HOME_FOLDER"/systemd/user/timers/* "/etc/systemd/user/"
    for servicefile in "$SCRIPTS_HOME_FOLDER/systemd/user/timers/"*.timer; do
        service=$(echo $servicefile | rev | cut -d'/' -f 1 | rev)
        echo $service
        systemctl --user enable --now $service
    done
fi
if [[ -d "$SCRIPTS_HOME_FOLDER"/systemd/system/services/ ]]; then
    echo 'installing system services'
    sudo cp "$SCRIPTS_HOME_FOLDER"/systemd/system/services/* "/etc/systemd/system/"
    for servicefile in "$SCRIPTS_HOME_FOLDER/systemd/system/services/"*; do
        service=$(echo $servicefile | rev | cut -d'/' -f 1 | rev)
        echo $service
        sudo systemctl enable --now $service
    done
fi
if [[ -d "$SCRIPTS_HOME_FOLDER"/systemd/system/timers/ ]]; then
    echo 'installing system timers'
    sudo cp "$SCRIPTS_HOME_FOLDER"/systemd/system/timers/* "/etc/systemtimersd/system/"
    for servicefile in "$SCRIPTS_HOME_FOLDER/systemd/system/timers/"*.timer; do
        service=$(echo $servicefile | rev | cut -d'/' -f 1 | rev)
        echo $service
        sudo systemctl enable --now $service
    done
fi
