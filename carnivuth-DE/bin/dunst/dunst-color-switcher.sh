#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/get_wal_color.sh"
get_wal_color
sed -i "s/background = \"#.*\"/background = \"${COLORS[13]}\"/g" "$HOME/.config/dunst/dunstrc" 
sed -i "s/forground = \"#.*\"/foreground = \"${COLORS[0]}\"/g" "$HOME/.config/dunst/dunstrc"
sed -i "s/frame_color = \"#.*\"/frame_color = \"${COLORS[1]}\"/g" "$HOME/.config/dunst/dunstrc"
killall dunst 
dunst &
