#!/bin/bash
MENU_NAME="kanshiprofile"
PROMPT="monitor layouts"

help_message(){
  echo " script for switching trough kanshi layouts"
}
list_elements_to_user(){
  grep profile ~/.config/kanshi/config | awk -F' ' '{print $2}'
}

exec_command_with_chosen_element(){
  kanshictl switch $1
}

source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/menu.sh"
