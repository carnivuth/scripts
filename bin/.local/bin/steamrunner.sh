#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

MENU_NAME="steamrunner"
PROMPT="steam games"
STEAM_APPS_FOLDER="$HOME/.steam/root/steamapps"

help_message(){
  echo "run steam games"
}

list_elements_to_user(){
  ls "$STEAM_APPS_FOLDER"/appmanifest_* | while read file;do
  grep name "$file" | awk -F'"' '{print $4}'
done
}

exec_command_with_chosen_element(){
  gameid="$(grep -l "$1" "$STEAM_APPS_FOLDER"/appmanifest_* | awk -F'_' '{print $2}' |awk -F '.' '{print $1}')"
  steam -silent "steam://rungameid/$gameid"
}

source "$SCRIPTS_LIB_FOLDER/menu.sh"
