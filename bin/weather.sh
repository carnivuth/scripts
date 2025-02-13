#!/usr/bin/env bash
source "$HOME/.config/scripts/settings.sh"

declare -A FLAGS
FLAGS_STRING=''

declare -A COMMANDS
COMMANDS[start]="start weather daemon"
COMMANDS[notify]="launch notification with weather"
COMMANDS[pre_stop]="daemon pre stop operations"
COMMANDS[get_weather]="pull weather informations"

WEATHER_SLEEP_TIME="10m"
WEATHER_APP_NOTIFICATION_NAME="weather"

function get_weather(){
  if [[ ! -f "$SCRIPTS_RUN_FOLDER/weather.json" ]];then echo "no weather to display, is the daemon running?"; exit 1; fi
  cat "$SCRIPTS_RUN_FOLDER/weather.json"
}

function pre_stop(){
  rm -f "$SCRIPTS_RUN_FOLDER/weather.json"
}

function start(){
  notify-send -u normal -a "$WEATHER_APP_NOTIFICATION_NAME" "started weather notification daemon"
  echo "started weather notification daemon"
  while true; do
    # get data from wttr
    text=$(curl -s "https://wttr.in?format=3")
    if [[ $? == 0 ]]; then
      tooltip=$(curl -s "https://wttr.in?format=4")
      if [[ $? == 0 ]]; then
        echo "{\"text\":\"$text\", \"tooltip\":\"$tooltip\"}" > "$SCRIPTS_RUN_FOLDER/weather.json"
      fi
    fi
    sleep $WEATHER_SLEEP_TIME
  done
}

function notify(){
  notify-send -u normal -a "$WEATHER_APP_NOTIFICATION_NAME" "$($0 get_weather | jq '.text' -r)"
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
