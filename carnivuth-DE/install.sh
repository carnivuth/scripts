#!/bin/bash

## check on settings.sh file, exit if not present
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
wf-recorder
htop
calc
tmux
seahorse
fzf
lazygit
newsboat
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
telegram-desktop
epapirus-icon-theme
brightnessctl
mpv-mpris
ttf-font-awesome
github-cli
socat
blueman
python-pywal
vim
vim-ale
kitty
obsidian
nm-connection-editor
dunst'

# install additional packages based on selected setup
if [[ "$answer" == "h" ]];then
  packets="$packets
  hyprland
  hyprlock
  noto-fonts-emoji
  hypridle
  greetd
  hyprpaper
  wev
  xdg-desktop-portal-hyprland
  ttf-jetbrains-mono-nerd
  waybar
  wofi
  slurp
  grim
  qt6-wayland
  wl-clipboard"

elif [[ "$answer" == "i" ]]; then
  packets="$packets
  xorg-xinput
  i3lock
  autorandr
  flameshot
  i3-wm
  picom
  polybar
  rofi
  feh
  "

fi

sudo pacman -S $packets

# setting path based on selected setup
if [[ "$answer" == "h" ]];then
  config_folder="hyprland-setup"
elif [[ "$answer" == "h" ]]; then
  config_folder="i3-setup"
fi

# installing config files
echo 'installing config files'
mkdir -p "$HOME/.config/"

for file in "$SCRIPTS_HOME_FOLDER/carnivuth-DE/$config_folder"/* ; do
  ln -sf "$SCRIPTS_HOME_FOLDER/carnivuth-DE/$config_folder/$file" "$HOME/.config/"
done

echo 'installing shell integration files'
ln -sf "$SCRIPTS_HOME_FOLDER/carnivuth-DE/.bashrc" "$HOME/"
ln -sf "$SCRIPTS_HOME_FOLDER/carnivuth-DE/.bash_aliases" "$HOME/"
