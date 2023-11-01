#!/bin/bash
source "$HOME/scripts/settings.sh"

# install packages
echo 'installing packages'
packets='pamixer xorg-xinput gnome-themes-extra jq bluez-utils loupe evince lightdm-webkit2-greeter lightdm-webkit-theme-litarvan light-locker lightdm ttf-dejavu mpv thunderbird thunar adwaita-icon-theme pop-icon-theme pavucontrol firefox brightnessctl ttf-font-awesome code python-pywal alacritty autorandr python-pywal feh conky flameshot i3-wm picom polybar rofi vlc blueman dunst'
sudo pacman -S $packets

# copy config files
echo 'coping config files'
 mkdir -p "$HOME/.config/"
cp -r "$SCRIPTS_HOME_FOLDER/carnivuth-DE/.config/"* "$HOME/.config/"

# setting up flameshot savePath folder
echo 'setting flameshot savePath folder'
if [[ ! -d "$FLAMESHOT_FOLDER" ]]; then
    mkdir -p "$FLAMESHOT_FOLDER"
fi
echo "savePath=$FLAMESHOT_FOLDER" >>"$HOME/.config/flameshot/flameshot.ini"

# setup gtk bookmarks
echo 'setup gtk bookmarks'

echo -e "$GTK_BOOKMARKS" >"$HOME/.config/gtk-4.0/bookmarks"
echo -e "$GTK_BOOKMARKS" >"$HOME/.config/gtk-3.0/bookmarks"

# creating bookmarks folders
echo 'creating bookmarks folders'
cat $HOME/.config/gtk-4.0/bookmarks | while read folder; do
    f=$(echo $folder | cut -d '/' -f 4-)
    if [[ ! -d "/$f" ]]; then
        mkdir -p "/$f"
    fi
done

# enabling lightdm
echo 'enabling lightdm'
sudo systemctl enable lightdm

# configuring workspaces on multiple monitors
echo 'configuring workspaces on multiple monitors'
sed -i "s/set \$screen1 /set \$screen1 $SCREEN1/g" $HOME/.config/i3/bindings
sed -i "s/set \$screen2 /set \$screen2 $SCREEN2/g" $HOME/.config/i3/bindings
