#!/bin/bash
source "$HOME/scripts/settings.sh"

# install packages
echo 'installing packages'
packets='pavucontrol firefox brightnessctl ttf-font-awesome code python-pywal alacritty autorandr python-pywal feh conky flameshot i3-wm picom polybar rofi vlc blueman dunst'
sudo pacman -S $packets

# copy config files
echo 'coping config files'
cp -r "$SCRIPTS_HOME_FOLDER/carnivuth-DE/.config/"* "$HOME/.config/"

# setting up flameshot savePath folder
echo 'setting flameshot savePath folder'
if [[! -d "$FLAMESHOT_FOLDER" ]]; then
    mkdir "$FLAMESHOT_FOLDER"
fi
echo "savePath=$FLAMESHOT_FOLDER" >>"$HOME/.config/flameshot/flameshot.ini"
