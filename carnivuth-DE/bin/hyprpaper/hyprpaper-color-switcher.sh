#!/bin/bash
hyprctl hyprpaper preload "$1"
hyprctl hyprpaper wallpaper eDP-1,"$1"
hyprctl hyprpaper wallpaper HDMI-A-1,"$1"
sed -i "s|^preload = .*|preload = $1|" $HOME/.config/hypr/hyprpaper.conf
sed -i "s|^wallpaper = \,.*|wallpaper = ,$1|" $HOME/.config/hypr/hyprpaper.conf
