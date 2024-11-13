#!/usr/bin/bash
MENU_NAME="clipboard"
PROMPT="copied content"
source "$HOME/.config/scripts/settings.sh"

help_message(){
  echo " script for opening clipboard history"
  echo " usage $0 "
}
list_elements_to_user(){
  cliphist list
}

exec_command_with_chosen_element(){
  echo "$1" | cliphist decode | wl-copy
}

source "$SCRIPTS_LIB_FOLDER/menu.sh"
