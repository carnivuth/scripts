#!/bin/bash

#import settings
source "$HOME/.config/scripts/settings.sh"

mkdir -p "$RECORDER_OUTPUT_PATH"

toggle(){
  pid="$(pidof $RECORDER)"
  if [[ "$pid" != "" ]]; then
    kill "$pid" >> "$SCRIPTS_LOGS_FOLDER/recorder.log" 2>&1
    notify-send -a "$RECORDER_APP_NAME_NOTIFICATION" -u "normal" "stop recording"
  else
    name="$(date +%s).mp4"
    echo "$name" >> "$SCRIPTS_LOGS_FOLDER/recorder.log" 2>&1
    notify-send -a "$RECORDER_APP_NAME_NOTIFICATION" -u "normal" "start recording"
    "$RECORDER" -f "$RECORDER_OUTPUT_PATH/$name" >> "$SCRIPTS_LOGS_FOLDER/recorder.log" 2>&1 &
  fi
}

case "$1" in
  "toggle")
    toggle
    ;;
  *)
    echo "usage $0 [toggle]"
    ;;
esac
