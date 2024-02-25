#!/bin/bash

## check on settings.sh file
if [[ ! -f "$HOME/scripts/settings.sh" ]]; then 
    echo 'no settings.sh file found, run: '
    echo "cp $HOME/scripts/settings.sh.sample $HOME/scripts/settings.sh"
    echo 'and edit the variables as you like'
    exit 1
fi 
source "$HOME/scripts/settings.sh"

# asking for i3 setup
echo "select setup to install [h/i]"
unset answer
read answer

# install packages
echo 'installing packages'
packets='
network-manager-applet 
playerctl 
pamixer 
gnome-themes-extra 
jq 
bluez-utils 
loupe 
evince 
ttf-dejavu 
mpv 
thunderbird 
thunar 
adwaita-icon-theme 
pop-icon-theme 
pavucontrol 
firefox 
brightnessctl 
ttf-font-awesome 
code 
conky 
blueman 
dunst'

# install additional packages based on selected setup
if [["$answer" == "h" ]];then
  packets="$packets Hyprland swaylock swayidle waybar wofi slurp grim wl-clipboard"
elif [["$answer" == "i" ]]; then
  packets="$packets 
  xorg-xinput
	lightdm-webkit2-greeter 
  alacritty 
  autorandr 
  python-pywal 
  flameshot 
  i3-wm 
  picom 
  polybar 
  rofi 
  feh 
  lightdm-webkit-theme-litarvan 
  light-locker 
  lightdm "

fi

sudo pacman -S $packets

# setting path based on selected setup
if [["$answer" == "h" ]];then
  config_folder="hyprland-setup"
elif [["$answer" == "h" ]]; then
  config_folder="i3-setup"
fi

# copy config files
echo 'coping config files'
mkdir -p "$HOME/.config/"
ln -s "$SCRIPTS_HOME_FOLDER/carnivuth-DE/$config_folder"* "$HOME/.config/"
