#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

declare -A FLAGS
FLAGS_STRING=''

declare -A COMMANDS
COMMANDS[toggle]="toggle screen recording"

toggle(){
  mkdir -p "$RECORDER_OUTPUT_PATH"
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

source "$SCRIPTS_LIB_FOLDER/cli.sh"
