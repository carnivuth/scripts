#!/bin/bash

install_dotfiles(){
# asking for setup
echo "select setup to install [h/i]"
unset answer
read answer

# install packages
echo 'installing packages'
packets='
figlet
yt-dlp
ffmpeg
gawk
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
  bemenu-wayland
  bemenu-ncurses
  bemenu
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

for file in "$SCRIPTS_DOTFILES_FOLDER/$config_folder"/* ; do
  ln -sf "$file" "$HOME/.config/"
done

echo 'installing shell integration files'
if [[ "$(grep 'source .*scripts.*bash_integration.sh' "$HOME/.bashrc" )" == "" ]]; then
    echo "source $SCRIPTS_DOTFILES_FOLDER/bash_integration.sh" >> "$HOME/.bashrc";
	fi
	# add bin to PATH variable if not present
	if [[ "$(grep '.*scripts.*bin.*' ~/.bashrc )" == "" ]]; then
		echo 'export PATH=$PATH:'"$SCRIPTS_BIN_FOLDER" >> "$HOME/.bashrc";
	fi
}

install_systemd_units(){
  # install packages
  echo 'installing packages'
  packets='curl borg newsboat upower jq rclone libsecret'
  sudo pacman -S $packets

# creating systemd folder
if [[ ! -d "$HOME/.config/systemd/user/" ]]; then
  mkdir -p "$HOME/.config/systemd/user/"
fi
# installing systemd services
cp -rf "$SCRIPTS_SYSTEMD_FOLDER/services/"*.service "$HOME/.config/systemd/user/"

# setting basolute paths
sed -i "s|\[\[HOME\]\]|${HOME}|g" "$HOME/.config/systemd/user/"*.service

# reload daemons
systemctl --user daemon-reload

# enable all services
for servicefile in "$SCRIPTS_SYSTEMD_FOLDER/services/"*.service; do
  service=$(echo "$servicefile" | rev | cut -d'/' -f 1 | rev)

  # enable service if is present in config variable
  if [[ "$ENABLED_SERVICES" =~ "$service" ]]; then
    echo "enabling $service"
    systemctl --user enable --now "$service"
  fi
done

# installing systemd timers
cp -rf "$SCRIPTS_SYSTEMD_FOLDER/timers/"*.service "$HOME/.config/systemd/user/"
cp -rf "$SCRIPTS_SYSTEMD_FOLDER/timers/"*.timer "$HOME/.config/systemd/user/"

# setting basolute paths
sed -i "s|\[\[HOME\]\]|${HOME}|g" "$HOME/.config/systemd/user/"*.service

# reload daemons
systemctl --user daemon-reload

# enable all services
for timerfile in "$SCRIPTS_SYSTEMD_FOLDER/timers/"*.timer; do
  timer=$(echo "$timerfile" | rev | cut -d'/' -f 1 | rev)

  # enable timer if is present in config variable
  if [[ "$ENABLED_TIMERS" =~ "$timer" ]]; then
    echo "enabling $timer"
    systemctl --user enable --now "$timer"
  fi
done
echo ""
echo "if you enable the backup service remember to run $HOME/scripts/systemd/bin/backup.sh init to initialize the borg repo"
}

## check on settings.sh file
if [[ ! -f "$HOME/scripts/settings.sh" ]]; then
  echo 'no settings.sh file found, run: '
  echo "cp $HOME/scripts/settings.sh.sample $HOME/scripts/settings.sh"
  echo 'and edit the variables as you like'
  exit 1
fi

source "$HOME/scripts/settings.sh"

case "$1" in
  "dotfiles")
    install_dotfiles
    ;;
  "systemd")
    install_systemd_units
    ;;
  *)
    install_dotfiles
    install_systemd_units
    ;;
esac
