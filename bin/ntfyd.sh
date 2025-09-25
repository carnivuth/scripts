#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/notify.sh"

declare -A FLAGS
declare -A FLAGS_DESCRIPTIONS
FLAGS_STRING=''

APP_NAME="ntfyd"
APP_ICON="/usr/share/icons/Papirus/16x16/apps/notifyconf.svg"

declare -A COMMANDS
COMMANDS[start]="start notification daemon"

get_param(){
  echo "$1" | jq -r "{$2} | to_entries | .[] | .value "
}

handle_message(){

  MSG="$1"
  message="$(get_param "$MSG" "message")"
  title="$(get_param "$MSG" "title")"
  attachment="$(get_param "$MSG" "attachment")"

  echo "$message"
  echo "$title"
  echo "$attachment"

  notification_body=""

  if [[ "$title" != "null" ]]; then
    notification_body="$notification_body $title $message"
  else
    notification_body="$notification_body $message"
  fi

  if [[ "$attachment" != "null" ]]; then

    attachment_url="$(get_param "$attachment" "url")"
    echo "$attachment_url"

    notification_body="$notification_body click to download stdout"
  fi

  echo "$notification_body"
  result="$(notify "normal" "$notification_body")"
  if [[ "$result" == 'download' ]]; then
    xdg-open "$attachment_url"
  fi
}

start(){

  notify "normal"  "started listening for notifications"
  stdbuf -oL  curl $NTFYD_DEBUG --retry 999 --retry-max-time 0 -s "$NTFYD_ENDPOINT/$NTFYD_TOPICS/json" | while read -r MSG; do

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

source "$SCRIPTS_LIB_FOLDER/cli.sh"
