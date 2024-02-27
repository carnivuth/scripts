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
telegram-desktop
epapirus-icon-theme
brightnessctl 
mpv-mpris
ttf-font-awesome 
code 
github-cli
htop
conky 
blueman 
obsidian
neovim
nm-connection-editor
dunst'

# install additional packages based on selected setup
if [[ "$answer" == "h" ]];then
  packets="$packets 
  hyprland 
  swaylock 
  kitty
  noto-fonts-emoji
  swayidle 
  greetd
  greetd-regreet
  chromium
  wev 
  xdg-desktop-portal-hyprland 
  ttf-jetbrains-mono-nerd
  waybar 
  wofi 
  slurp 
  grim 
  cage
  wl-clipboard"
elif [[ "$answer" == "i" ]]; then
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
LV_BRANCH='release-1.3/neovim-0.9' bash <\
  (curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
 
# setting path based on selected setup
if [[ "$answer" == "h" ]];then
  config_folder="hyprland-setup"
elif [[ "$answer" == "h" ]]; then
  config_folder="i3-setup"
fi

# copy config files
echo 'coping config files'
mkdir -p "$HOME/.config/"
ln -s "$SCRIPTS_HOME_FOLDER/carnivuth-DE/$config_folder/"* "$HOME/.config/"

if [[ "$answer" == "h" ]];then
  echo "ln -s $HOME/scripts/lib/wofi_standard.sh $HOME/scripts/lib/menu_standard.sh"
elif [[ "$answer" == "h" ]]; then
  echo "ln -s $HOME/scripts/lib/rofi_standard.sh $HOME/scripts/lib/menu_standard.sh"
fi

# adding elements to path
if [[ "$(cat $HOME/.bashrc | grep $SCRIPTS_APPLETS_FOLDER)" == "" ]]; then
    echo "export PATH=$SCRIPTS_APPLETS_FOLDER:"'$PATH' >>"$HOME/.bashrc"
    export PATH="$SCRIPTS_APPLETS_FOLDER:$PATH"
fi
