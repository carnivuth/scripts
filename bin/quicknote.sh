#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

FLAGS_STRING=''
declare -A FLAGS

declare -A COMMANDS
COMMANDS[new]="create new note"

if [[ "$DESKTOP_SESSION" == 'sway' ]];then idle_daemon="swayidle";fi
if [[ "$DESKTOP_SESSION" == 'hyprland' ]];then idle_daemon="hypridle";fi

new(){

  $NOTE_TERMINAL_CMD $EDITOR

}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
