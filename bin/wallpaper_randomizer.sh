#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

declare -A FLAGS
declare -A FLAGS_DESCRIPTIONS
FLAGS_STRING=''

declare -A COMMANDS
COMMANDS[change_wall]="change wallpaper randomly"

function change_wall(){
  wallpaper=$(find $THEMESWITCHER_FOLDERS -type f | shuf -n 1)
  hyprctl hyprpaper wallpaper ,"$wallpaper"
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
