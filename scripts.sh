#!/bin/bash
SWAY_DEPS='
sway
swaybg
swayidle
swaylock'

HYPRLAND_DEPS='
hyprland
hyprlock
hypridle
hyprpaper xdg-desktop-portal-hyprland'

DEPS='
pandoc-cli
starship
rsync
stow
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
alacritty
obsidian
nm-connection-editor
noto-fonts-emoji
greetd
wev
ttf-jetbrains-mono-nerd
waybar
bemenu-wayland
bemenu-ncurses
bemenu
slurp
grim
qt6-wayland
wl-clipboard
dunst
curl
borg
rclone
newsboat
upower
libsecret'

install_systemd_units(){

# installing systemd services
stow --target="$HOME/.config/systemd/user" systemd
source "$HOME/.config/scripts/settings.sh"

systemctl --user daemon-reload

# enable all services
for service in ${ENABLED_SERVICES}; do
  echo "enabling $service"
  systemctl --user enable --now "$service"
done

# enable all services
for timer in ${ENABLED_TIMERS}; do
  echo "enabling $timer"
  systemctl --user enable --now "$timer"
done
echo ""
echo "if you enable the backup service remember to run backup.sh init to initialize the borg repo"
}

## check on settings.sh file
if [[ ! -f "etc/scripts/settings.sh" ]]; then
  echo 'no settings.sh file found, run: '
  echo "cp etc/scripts/settings.sh.sample etc/scripts/settings.sh"
  echo 'and edit the variables as you like'
  exit 1
fi

OPTIND=1
WINDOW_MANAGER='hyprland'
while getopts w: flag; do
  case "${flag}" in
    w) WINDOW_MANAGER=${OPTARG} ; shift; shift ;;
    *) echo "${flag} is unsupported" ; exit 1 ;;
  esac
done

case "$1" in
  uninstall)
    echo "removing packages"
    if [[ "$WINDOW_MANAGER" == 'hyprland' ]];then
    sudo pacman -Rns $DEPS $HYPRLAND_DEPS
    elif [[ "$WINDOW_MANAGER" == 'sway' ]];then
    sudo pacman -Rns $DEPS $SWAY_DEPS
    fi
    stow --target="$HOME/.config" -D etc
    stow --target="$HOME/.local/lib" -D lib
    stow --target="$HOME/.local/bin" -D bin
    stow --target="$HOME/.config/systemd/user" -D systemd
    systemctl --user daemon-reload
    sed '/source \$HOME\/\.config\/scripts\/bash_integration.sh/d' -i "$HOME/.bashrc"
    ;;
  *)
    mkdir -p "$HOME/.config/systemd/user" "$HOME/.local/bin" "$HOME/.local/lib"
    echo 'installing packages'
    if [[ "$WINDOW_MANAGER" == 'hyprland' ]];then
    sudo pacman -S $DEPS $HYPRLAND_DEPS
    elif [[ "$WINDOW_MANAGER" == 'sway' ]];then
    sudo pacman -S $DEPS $SWAY_DEPS
    fi
    # source shell integration script
    if [[ "$(grep 'source $HOME/.config/scripts/bash_integration.sh' "$HOME/.bashrc" )" == "" ]]; then
      echo 'source $HOME/.config/scripts/bash_integration.sh' >> "$HOME/.bashrc";
    fi
    stow --target="$HOME/.config" etc
    stow --target="$HOME/.local/lib" lib
    stow --target="$HOME/.local/bin" bin
    install_systemd_units
    "$HOME/.local/bin/themeswitcher.sh" -b fzf
    ;;
esac
