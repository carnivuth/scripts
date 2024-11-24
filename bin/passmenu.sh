#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"

MENU_NAME="passmenu"
PROMPT="passwords"

help_message(){
  echo "quick access to pass password storage"
}

list_elements_to_user(){
  find ~/.password-store/ -name '*.gpg'| sed -e 's|.*.password-store/||g' -e 's|.gpg||g'
}

exec_command_with_chosen_element(){
  pass -c "$1"
}

source "$SCRIPTS_LIB_FOLDER/menu.sh"
