#!/bin/bash
source "$HOME/scripts/settings.sh"

get_param(){
  echo "$1" | jq -r "{$2} | to_entries | .[] | .value "
}

open_connection(){
  stdbuf -oL  curl -s "$NTFYD_ENDPOINT/$NTFYD_TOPICS/json" >> "$NTFYD_MESSAGE_BUFFER"
}

help_command(){
        echo "usage $0 [start|stop]"
}

stop_command(){
  rm -f "$NTFYD_MESSAGE_BUFFER"
}

start_command(){

  open_connection &

  tail -f "$SCRIPTS_RUN_FOLDER/ntfy.run" | while read MSG; do

    event="$(get_param "$MSG" "event")"
    id="$(get_param "$MSG" "id")"
    time="$(get_param "$MSG" "time")"
    topic="$(get_param "$MSG" "topic")"

    echo "$topic"
    echo "$event"
    echo "$id"
    echo "$time"

    case "$event" in

      "message")

        message="$(get_param "$MSG" "message")"
        title="$(get_param "$MSG" "title")"

        if [[ "$title" != "null" ]]; then
          notify-send -a "$NTFYD_APP_NAME_NOTIFICATION" -u "normal" "$title $message"
        else
          notify-send -a "$NTFYD_APP_NAME_NOTIFICATION" -u "normal" "$message"
        fi
        ;;

    esac

  done
}

case "$1" in
  "start")
    start_command
    ;;
  "stop")
    stop_command
    ;;
  *)
    help_command
    ;;
esac
