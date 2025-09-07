#!/bin/bash
SWAY_DEPS='
sway
swaybg
swayidle
swaylock'

HYPRLAND_DEPS='
hyprland
hyprshot
hyprpolkitagent
hyprlock
hypridle
hyprpaper
xdg-desktop-portal-hyprland'

DEPS='
python-pyacoustid
python-pylast
chromaprint
python-pymad
beets
cdrtools
udiskie
bash-completion
wol
parallel
gst-plugin-spotify
inotify-tools
pass
wireshark-cli
fastfetch
nextcloud-client
pinentry-bemenu
kanshi
btop
cliphist
which
pandoc-cli
starship
rsync
stow
yt-dlp
ffmpeg
gawk
wf-recorder
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
ranger
thunderbird
adwaita-icon-theme
libnotify
pop-icon-theme
pavucontrol
firefox
telegram-desktop
papirus-icon-theme
brightnessctl
mpv-mpris
ttf-font-awesome
github-cli
socat
blueman
vim
alacritty
obsidian
nm-connection-editor
noto-fonts-emoji
noto-fonts-cjk
greetd
greetd-tuigreet
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
retroarch
newsboat
upower
libsecret'

install_systemd_units(){

  source "$HOME/.config/scripts/settings.sh"

  echo 'installing systemd units'
  systemctl --user daemon-reload

  # enable all services
  for service in ${ENABLED_SERVICES}; do
    echo "enabling $service"
    systemctl --user enable --now "$service"
  done

  # enable all services templates
  for service in ${TEMPLATE_SERVICES}; do
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

function configure_wallpaper(){
  if [[ ! -e "$HOME/.config/hypr/hyprpaper.conf" ]]; then
    echo 'create wallpaper config'
    "$HOME/.local/bin/L.sh" -b fzf wallpaper
  fi
}

function configure_hook(){
  # create post merge hook for update
  if [[ ! -e ".git/hooks/post-merge" ]]; then
    echo 'create post-merge hook'
    echo  -e "#!/bin/bash\n./scripts.sh" > ".git/hooks/post-merge"
  fi
  chmod +x ".git/hooks/post-merge"
}

function configure_monitors(){
  # create default monitor configuration file if does not exists
  if [[ ! -e "$HOME/.config/hypr/monitors.conf" ]]; then
    echo 'create monitor config'
    echo  "monitor = , preferred, auto, auto" > "$HOME/.config/hypr/monitors.conf"
  fi
}

function configure_ssh(){
# add include ssh config
mkdir -p "$HOME/.ssh"
touch "$HOME/.ssh/config"
# check if configuration file exist and include ssh config for homelab
if  [[ -f "$HOME/.ssh/config" ]] && ! grep -q 'Include ~/.config/ssh/config' "$HOME/.ssh/config" ; then
  echo 'include ssh config'
  echo  "Include ~/.config/ssh/config" >> "$HOME/.ssh/config"
fi
}

function configure_gnupg(){
# add link to gpg folder
mkdir -p "$HOME/.gnupg/"
chmod 700 "$HOME/.gnupg/"
echo "pinentry-program /bin/pinentry-bemenu" > "$HOME/.gnupg/gpg-agent.conf"
}

function configure_system_settings(){

SCRIPT_PATH="$(dirname "$(realpath "$0")")"
if [[ ! -f "$SCRIPT_PATH/etc/scripts/settings.sh" ]]; then echo "no setting.sh file found, exiting"; exit 1; fi
source "$HOME/.config/scripts/settings.sh"

echo "configure greetd"
sudo cp "$SCRIPTS_LIB_FOLDER/greetd/config.toml" "/etc/greetd/config.toml"

echo "configure pam for unlock gnome keyring at startup"
sudo cp "$SCRIPTS_LIB_FOLDER/pam.d/greetd" "/etc/pam.d/greetd"

echo "configuring sudo to execute pacman without password for update automation"
echo "$USER ALL=(ALL:ALL) NOPASSWD:/bin/pacman" |sudo tee "/etc/sudoers.d/$USER"
}

SCRIPT_PATH="$(dirname "$(realpath "$0")")"

# check on settings.sh file
if [[ ! -f "$SCRIPT_PATH/etc/scripts/settings.sh" ]]; then
  echo 'no settings.sh file found, creating default one'
  echo 'source $HOME/.config/scripts/settings.sh.sample' > "$SCRIPT_PATH/etc/scripts/settings.sh"
  grep '""' etc/scripts/settings.sh.sample >> "$SCRIPT_PATH/etc/scripts/settings.sh"
fi

OPTIND=1

# flag to manage packages, script install packages as default
PACKAGES="TRUE"
while getopts p flag; do
  case "${flag}" in
    p) PACKAGES="FALSE"; shift ;;
    *) echo "${flag} is unsupported" ; exit 1 ;;
  esac
done

case "$1" in
  uninstall)

    stow --target="$HOME/.config" -D etc
    stow --target="$HOME/.local/lib" -D lib
    stow --target="$HOME/.local/bin" -D bin
    stow --target="$HOME/.config/systemd/user" -D systemd
    systemctl --user daemon-reload
    sed '/source \$HOME\/\.config\/scripts\/settings.sh/d' -i "$HOME/.bashrc"
    sed 'Include ~/.config/ssh/config' -i "$HOME/.ssh/config"

    echo "removing packages"
    if [[ "$PACKAGES" == 'TRUE' ]];then
      sudo pacman -Rns --noconfirm $DEPS $HYPRLAND_DEPS
    fi
    ;;

  system)
    configure_system_settings
    ;;

  *)
    mkdir -p "$HOME/.config/" "$HOME/.config/systemd/user" "$HOME/.local/bin" "$HOME/.local/lib"

    echo 'installing packages'
    if [[ "$PACKAGES" == 'TRUE' ]];then
      sudo pacman -S --noconfirm $DEPS $HYPRLAND_DEPS
    fi

    echo 'installing configs'
    stow --target="$HOME/.config" etc
    stow --target="$HOME/.local/lib" lib
    stow --target="$HOME/.local/bin" bin
    stow --target="$HOME/.config/systemd/user" systemd

    echo 'adding bash integration'
    if [[ "$(grep 'source $HOME/.config/scripts/settings.sh' "$HOME/.bashrc" )" == "" ]]; then
      echo 'source $HOME/.config/scripts/settings.sh' >> "$HOME/.bashrc";
    fi

    install_systemd_units
    configure_monitors
    configure_wallpaper
    configure_ssh
    configure_gnupg
    configure_hook
    ;;
esac
