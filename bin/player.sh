#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/control_mpv.sh"

declare -A FLAGS
declare -A FLAGS_DESCRIPTIONS
FLAGS_STRING=''

declare -A COMMANDS
COMMANDS[toggle]="toggle player"
COMMANDS[quit]="quit player"

function toggle(){
toggle_mpv
}

function quit(){
quit_mpv
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
