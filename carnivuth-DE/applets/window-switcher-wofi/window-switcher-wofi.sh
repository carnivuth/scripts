#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/menu_standard.sh"
menu_theme_setup "window-switcher-wofi"
prompt="window switcher"
# print menu filtering elements with jq
chosen="$(hyprctl clients -j | jq -r '.[].title | select(length > 0)'| menu_cmd $prompt)"

# focus selected window
if [[ "$chosen" != '' ]];then
hyprctl dispatch focuswindow "title:$chosen"
fi
