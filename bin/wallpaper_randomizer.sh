#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

declare -A FLAGS
FLAGS_STRING=''

declare -A COMMANDS
COMMANDS[change_wall]="change wallpaper randomly"

function change_wall(){

  current_wall=$(hyprctl hyprpaper listloaded)
  wallpaper=$(find $THEMESWITCHER_FOLDERS -type f ! -name "$(basename "$current_wall")" | shuf -n 1)
  hyprctl hyprpaper reload ,"$wallpaper"
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
