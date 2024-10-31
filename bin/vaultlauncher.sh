#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

MENU_NAME="vaultlauncher"
PROMPT="obsidian vaults"

help_message(){
  echo "script for quick access to obsidian vaults"
}
list_elements_to_user(){
  jq -r '.vaults[].path' "$HOME/.config/obsidian/obsidian.json"
}

exec_command_with_chosen_element(){
  if [[ -d "$1" ]];then
    obsidian "obsidian://open?path=$1" &
  fi
}

source "$SCRIPTS_LIB_FOLDER/menu.sh"
