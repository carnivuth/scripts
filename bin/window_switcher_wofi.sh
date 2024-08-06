#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER"/"$MENU_BACKEND"_standard.sh
if [[ "$XDG_CURRENT_DESKTOP" != 'Hyprland' ]]; then echo 'not in hyprland session'; exit 1; fi
menu_theme_setup "window_switcher_wofi"
prompt="window switcher"
# print menu filtering elements with jq
chosen="$(hyprctl clients -j | jq -r '.[].title | select(length > 0)'| menu_cmd "$prompt")"

# focus selected window
if [[ "$chosen" != '' ]];then
hyprctl dispatch focuswindow "title:$chosen"
fi
