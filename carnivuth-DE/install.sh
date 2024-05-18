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
seahorse
fzf
lazygit
btop
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
code 
github-cli
htop
socat
blueman 
python-pywal 
vim
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
  swayidle 
  greetd
  hyprpaper
  greetd-regreet
  wev 
  xdg-desktop-portal-hyprland 
  ttf-jetbrains-mono-nerd
  waybar 
  wofi 
  slurp 
  grim 
  cage
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

# installing lunarvim
echo "install lvim [y/N]"
unset answer_lvim
read answer_lvim
if [[ "$answer_lvim" == "y" ]];then

  echo "installing lunar vim ide"
  dependencies="
  neovim
  git
  make
  npm
  nodejs
  cargo
  ripgrep
  lazygit
  "
  sudo pacman -S $dependencies
  
  LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
fi 
# setting path based on selected setup
if [[ "$answer" == "h" ]];then
  config_folder="hyprland-setup"
elif [[ "$answer" == "h" ]]; then
  config_folder="i3-setup"
fi

# installing config files
echo 'installing config files'
mkdir -p "$HOME/.config/"
ln -sf $SCRIPTS_HOME_FOLDER/carnivuth-DE/$config_folder/* "$HOME/.config/"

echo 'installing home files'
ln -sf "$SCRIPTS_HOME_FOLDER/carnivuth-DE/.bashrc" "$HOME/"
ln -sf "$SCRIPTS_HOME_FOLDER/carnivuth-DE/.bash_aliases" "$HOME/"
