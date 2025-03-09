#!/bin/bash
# function for printing notification

notify(){
  if [[ -z $APP_NAME ]]; then "echo APP_NAME not defined"; exit 1; fi
  if [[ -z $APP_ICON ]]; then "echo APP_ICON not defined"; exit 1; fi
  if [[ -z $1 ]]; then "pass urgency as first parameter"; exit 1; fi
  if [[ -z $2 ]]; then "pass message as first parameter"; exit 1; fi

  notify-send -i "$APP_ICON" -a "$APP_NAME" -u "$1"  "$2"
}
