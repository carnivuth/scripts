#!/bin/bash
# check if this is an hyprland session, exit otherwise
if [[ "$XDG_CURRENT_DESKTOP" != 'Hyprland' ]]; then echo 'not in hyprland session'; exit 1; fi

MENU_NAME="window_switcher"
PROMPT="window switcher"

help_message(){
  echo " script for focusing specific windows based on window name, works only under wayland"
}
list_elements_to_user(){
  hyprctl clients -j | jq -r '.[].title | select(length > 0)'
}

exec_command_with_chosen_element(){
  hyprctl dispatch focuswindow "title:$1"
}

source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/menu.sh"
