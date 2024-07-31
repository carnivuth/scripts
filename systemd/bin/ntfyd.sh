#!/bin/bash
source "$HOME/scripts/settings.sh"

get_param(){
        echo "$1" | jq -r "{$2} | to_entries | .[] | .value "
}

websocat  "$NTFYD_ENDPOINT/$NTFYD_TOPICS/ws" | while read MSG; do

  event="$(get_param "$MSG" "event")"
  id="$(get_param "$MSG" "id")"
  time="$(get_param "$MSG" "time")"
  topic="$(get_param "$MSG" "topic")"

  echo "$topic"
  echo "$event"
  echo "$id"
  echo "$time"

  if  [[ "$event" == "message" ]]; then
    message="$(get_param "$MSG" "message")"
    notify-send -a "$NTFYD_APP_NAME_NOTIFICATION" -u "normal" "$message"
  fi

done
