#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/notify.sh"

FLAGS_STRING=''
declare -A FLAGS
declare -A FLAGS_DESCRIPTIONS

declare -A COMMANDS
COMMANDS[toggle]="toggle caffeine mode"
COMMANDS[on]="turn on caffein mode"
COMMANDS[off]="turn off caffein mode"
COMMANDS[check_status]="check caffeine mode status"

if [[ "$DESKTOP_SESSION" == 'sway' ]];then idle_daemon="swayidle";fi
if [[ "$DESKTOP_SESSION" == 'hyprland' ]];then idle_daemon="hypridle";fi

STATUS_FILE="$SCRIPTS_RUN_FOLDER/caffeine.status"

APP_NAME="Caffeine mode"
APP_ICON="/usr/share/icons/Papirus/16x16/apps/kaffeine.svg"

off(){
  if ! pgrep $idle_daemon;then
    $idle_daemon &
    echo 0 > "$STATUS_FILE"
    notify low "caffeine mode off"

  fi
}

on(){
  if pgrep $idle_daemon;then
    kill -9 "$(pgrep $idle_daemon )"
  fi
  echo 1 > "$STATUS_FILE"
  notify low "caffeine mode on"
}

toggle(){
  if pgrep $idle_daemon;then
     on
  else
    off
  fi
}

function check_status(){
  status="$(cat "$STATUS_FILE")"
  if [[ "$status" == "1" ]];then
      text=" "
      tooltip="caffeine mode on"
    else
      text=" "
      tooltip="caffeine mode off"
    fi
    echo "{ \"text\":\"$text\",\"tooltip\":\"$tooltip\"}" |jq --unbuffered --compact-output
  inotifywait -m -e close_write "$STATUS_FILE" | while read event; do
  status="$(cat "$STATUS_FILE")"
  if [[ "$status" == "1" ]];then
      text=" "
      tooltip="caffeine mode on"
    else
      text=" "
      tooltip="caffeine mode off"
    fi
    echo "{ \"text\":\"$text\",\"tooltip\":\"$tooltip\"}" |jq --unbuffered --compact-output
  done
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
