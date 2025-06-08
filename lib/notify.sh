#!/bin/bash
# function for printing notification

notify(){
  if [[ -z $APP_NAME ]]; then "echo APP_NAME not defined"; exit 1; fi
  if [[ -z $APP_ICON ]]; then "echo APP_ICON not defined"; exit 1; fi
  if [[ -z $1 ]]; then "pass urgency as first parameter"; exit 1; fi
  if [[ -z $2 ]]; then "pass message as first parameter"; exit 1; fi

  # display notification only if urgency level is enabled in configs
  if echo $NOTIFICATION_LEVELS | grep -q "$1"; then
    notify-send -i "$APP_ICON" -a "$APP_NAME" -u "$1"  "$2"
  fi
}
