#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

get_param(){
  echo "$1" | jq -r "{$2} | to_entries | .[] | .value "
}

HELP_MESSAGE="usage $0 [start]"

handle_message(){

  MSG="$1"
  message="$(get_param "$MSG" "message")"
  title="$(get_param "$MSG" "title")"
  attachment="$(get_param "$MSG" "attachment")"

  echo "$message"
  echo "$title"
  echo "$attachment"

  notification_body=""
  notification_params=""

  if [[ "$title" != "null" ]]; then
    notification_body="$notification_body $title $message"
  else
    notification_body="$notification_body $message"
  fi

  if [[ "$attachment" != "null" ]]; then

    attachment_url="$(get_param "$attachment" "url" | sed 's|\(.*\)/file/\(.*\)|\1/ntfy/file/\2|g' )"
    echo "$attachment_url"

    notification_body="$notification_body click to download stdout"
    notification_params=--action='download=download attachment'
  fi

  echo "$notification_body"
  result="$(notify-send -i "$NTFYD_NOTIFY_ICON" -a "$NTFYD_APP_NAME_NOTIFICATION" -u "normal" $notification_params "$notification_body")"
  if [[ "$result" == 'download' ]]; then
    xdg-open "$attachment_url"
  fi
}

start_command(){

notify-send -i "$NTFYD_NOTIFY_ICON" -a "$NTFYD_APP_NAME_NOTIFICATION" -u "normal"  "started listening for notifications"
  stdbuf -oL  curl -s "$NTFYD_ENDPOINT/$NTFYD_TOPICS/json" | while read -r MSG; do

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
      handle_message "$MSG"
      ;;
  esac

done
}

case "$1" in
  "start")
    start_command
    ;;
  *)
    echo "$HELP_MESSAGE"
    ;;
esac
