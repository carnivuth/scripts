#!/bin/bash
source "$HOME/scripts/settings.sh"

# install packages 
echo 'installing packages'
packets='alacritty autorandr conky flameshot i3-wm picom polybar rofi vlc'
sudo pacman -S $packets

# copy config files
echo 'coping config files'
cp -r "$SCRIPTS_HOME_FOLDER/carnivuth-DE/.config/"* "$HOME/.config/"