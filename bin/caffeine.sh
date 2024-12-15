#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

FLAGS_STRING=''
declare -A FLAGS

declare -A COMMANDS
COMMANDS[toggle]="toggle connection to vpn configured in settings file"
COMMANDS[check_status]="check if idle daemon is running"

if [[ "$DESKTOP_SESSION" == 'sway' ]];then idle_daemon="swayidle";fi
if [[ "$DESKTOP_SESSION" == 'hyprland' ]];then idle_daemon="hypridle";fi

toggle(){

  if pgrep $idle_daemon;then
    kill -9 "$(pgrep $idle_daemon )"
  else
    $idle_daemon &
  fi
}

function check_status(){
  while true ; do
  if pgrep $idle_daemon;then
      text=" "
      tooltip="caffeine mode off"
    else
      text=" "
      tooltip="caffeine mode on"
    fi
    echo "{ \"text\":\"$text\",\"tooltip\":\"$tooltip\"}" |jq --unbuffered --compact-output
    sleep 5s
  done
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
