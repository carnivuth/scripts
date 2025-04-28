#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

# check if this is an hyprland session, exit otherwise
if [[ "$XDG_CURRENT_DESKTOP" != 'Hyprland' ]]; then echo 'not in hyprland session'; exit 1; fi

list_window(){
  hyprctl clients -j | jq -r '.[].title | select(length > 0)' | sed 's/^/window:/g'
}

exec_command_with_chosen_element(){
  hyprctl dispatch focuswindow "title:$1"
}
