#!/bin/bash
source "$HOME/scripts/settings.sh"

# install packages
echo 'installing packages'
packets='ttf-dejavu mpv thunderbird thunar adwaita-icon-theme pop-icon-theme pavucontrol firefox brightnessctl ttf-font-awesome code python-pywal alacritty autorandr python-pywal feh conky flameshot i3-wm picom polybar rofi vlc blueman dunst'
sudo pacman -S $packets

# copy config files
echo 'coping config files'
cp -r "$SCRIPTS_HOME_FOLDER/carnivuth-DE/.config/"* "$HOME/.config/"

# setting up flameshot savePath folder
echo 'setting flameshot savePath folder'
if [[ ! -d "$FLAMESHOT_FOLDER" ]]; then
    mkdir "$FLAMESHOT_FOLDER"
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
        mkdir "/$f"
    fi
done
