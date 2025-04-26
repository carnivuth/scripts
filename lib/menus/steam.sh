#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

STEAM_APPS_FOLDER="$HOME/.steam/root/steamapps"

list_steam(){
  grep 'name' $STEAM_APPS_FOLDER/appmanifest_*  | awk -F'"' '{print $4}' | sed 's/^/steam:/g'
}

run_steam(){
  gameid="$(grep -l "$1" "$STEAM_APPS_FOLDER"/appmanifest_* | awk -F'_' '{print $2}' |awk -F '.' '{print $1}')"
  steam -silent "steam://rungameid/$gameid" >> "$SCRIPTS_LOGS_FOLDER/steamrunner.log" 2>&1
}
