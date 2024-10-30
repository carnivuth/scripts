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
fd
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
adwaita-icon-theme
libnotify
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

echo 'installing systemd units'
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
  echo 'echo 'source $HOME/.config/scripts/settings.sh.sample' > $HOME/scripts/etc/.config/settings.sh'
  echo 'cat $HOME/scripts/etc/.config/settings.sh.sample >> $HOME/scripts/etc/.config/settings.sh'
  echo 'and edit the variables as you like'
  exit 1
fi

OPTIND=1
# FLAG TO MANAGE PACKAGES, SCRIPT DOES INSTALL PACKAGES AS DEFAULT
PACKAGES="TRUE"
while getopts p flag; do
  case "${flag}" in
    p) PACKAGES="FALSE"; shift ;;
    *) echo "${flag} is unsupported" ; exit 1 ;;
  esac
done

function configure_wallpaper(){
  if [[ ! -e "$HOME/.config/hypr/hyprpaper.conf" ]]; then
    echo 'create wallpaper config'
  "$HOME/.local/bin/themeswitcher.sh" -b fzf
  fi }

function configure_hook(){
  # create default monitor configuration file if does not exists
  if [[ ! -e ".git/hooks/post-merge" ]]; then
    echo 'create post-merge hook'
    echo  -e "#!/bin/bash\n./scripts.sh -p" > ".git/hooks/post-merge"
  fi
}

function configure_monitors(){
  # create default monitor configuration file if does not exists
  if [[ ! -e "$HOME/.config/hypr/monitors.conf" ]]; then
    echo 'create monitor config'
    echo  "monitor = , preferred, auto, auto" > "$HOME/.config/hypr/monitors.conf"
  fi
}

case "$1" in
  uninstall)
    echo "removing packages"
    if [[ "$PACKAGES" == 'TRUE' ]];then
    sudo pacman -Rns $DEPS $HYPRLAND_DEPS $SWAY_DEPS
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
    if [[ "$PACKAGES" == 'TRUE' ]];then
    sudo pacman -S $DEPS $HYPRLAND_DEPS $SWAY_DEPS
    fi

    echo 'adding bash integration'
    if [[ "$(grep 'source $HOME/.config/scripts/bash_integration.sh' "$HOME/.bashrc" )" == "" ]]; then
      echo 'source $HOME/.config/scripts/bash_integration.sh' >> "$HOME/.bashrc";
    fi

    echo 'installing configs'
    stow --target="$HOME/.config" etc
    stow --target="$HOME/.local/lib" lib
    stow --target="$HOME/.local/bin" bin

    install_systemd_units
    configure_monitors
    configure_wallpaper
    configure_hook
    ;;
esac
