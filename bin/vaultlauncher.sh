#!/bin/bash
source "$HOME/scripts/settings.sh"

MENU_NAME="vaultlauncher"
PROMPT="obsidian vaults"

help_message(){
  echo "script for quick access to obsidian vaults"
}
list_elements_to_user(){
  jq -r '.vaults[].path' "$HOME/.config/obsidian/obsidian.json"
}

exec_command_with_chosen_element(){
  obsidian "obsidian://open?path=$1" &
}

source "$SCRIPTS_LIB_FOLDER/menu.sh"
