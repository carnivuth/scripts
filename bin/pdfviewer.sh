#!/usr/bin/bash
MENU_NAME="pdfviewer"
PROMPT="pdfs"
source "$HOME/.config/scripts/settings.sh"

help_message(){
  echo " script for opening pdfs"
  echo " usage $0"
}
list_elements_to_user(){
  echo -e "$(for dir in $PDFVIEWER_FOLDERS; do ls -d "$dir"/*/; done)"
}

exec_command_with_chosen_element(){
  if [ -f "$chosen" ]; then
    evince "$chosen"
  fi
}

source "$SCRIPTS_LIB_FOLDER/menu.sh"
