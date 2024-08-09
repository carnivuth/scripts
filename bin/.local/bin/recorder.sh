#!/bin/bash

#import settings
source "$HOME/.config/scripts/settings.sh"

mkdir -p "$RECORDER_OUTPUT_PATH"

start_command(){
  name="$(date +%s).mp4"
  echo "$name" >> "$SCRIPTS_LOGS_FOLDER/recorder.log" 2>&1
  notify-send -a "$RECORDER_APP_NAME_NOTIFICATION" -u "normal" "start recording"
  "$RECORDER" -f "$RECORDER_OUTPUT_PATH/$name" >> "$SCRIPTS_LOGS_FOLDER/recorder.log" 2>&1 &
}

stop_command(){
  pid="$(pidof $RECORDER)"
  if [[ "$pid" != "" ]]; then
    kill "$pid" >> "$SCRIPTS_LOGS_FOLDER/recorder.log" 2>&1
    notify-send -a "$RECORDER_APP_NAME_NOTIFICATION" -u "normal" "stop recording"
  fi
  echo ""
}

case "$1" in
  "start")
    stop_command
    start_command
    ;;
  "stop")
    stop_command
    ;;
  *)
    echo "usage $0 [start|stop]"
    ;;
esac
