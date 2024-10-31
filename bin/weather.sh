#!/usr/bin/env bash
# get_weather.sh
source "$HOME/.config/scripts/settings.sh"

WEATHER_SLEEP_TIME="10m"
HELP_MESSAGE="usage $0 [start|get_weather]"

function get_weather(){
  if [[ ! -f "$SCRIPTS_RUN_FOLDER/weather.json" ]];then echo "no weather to display, is the daemon running?"; exit 1; fi
  cat "$SCRIPTS_RUN_FOLDER/weather.json"
}

function pre_stop(){
  rm -f "$SCRIPTS_RUN_FOLDER/weather.json"
}


function start(){
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


case "$1" in
  "start")
    start
    ;;
  "pre_stop")
    pre_stop
    ;;
  "get_weather")
    get_weather
    ;;
  *)
    echo "$HELP_MESSAGE"
    ;;
esac
