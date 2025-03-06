#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

declare -A FLAGS
FLAGS_STRING=''

declare -A COMMANDS
COMMANDS[start]="start nextcloud sync daemon daemon"
COMMANDS[init]="setup credentials in keyring"
COMMANDS[nxt_sync]="run a single sync operation"

check(){
  if ! secret-tool lookup nextcloud-repository nextcloud_username > /dev/null 2>&1 || ! secret-tool lookup nextcloud-repository nextcloud_password > /dev/null 2>&1; then
    notify-send -i "$NXTCDD_NOTIFY_ICON" -a "$NXTCDD_APP_NAME_NOTIFICATION" -u "critical"  "username or password are not set in keyring"
    return 1
  fi
  if test -z $NEXTCLOUD_URL; then
    notify-send -i "$NXTCDD_NOTIFY_ICON" -a "$NXTCDD_APP_NAME_NOTIFICATION" -u "critical"  "remote url not set in config file"
    return 1
  fi
  return 0
}

nxt_sync(){
  check || exit 1
  username="$(secret-tool lookup nextcloud-repository nextcloud_username)"
  password="$(secret-tool lookup nextcloud-repository nextcloud_password)"
  if ! nextcloudcmd -u "$username" -p "$password" --non-interactive --exclude $HOME/.config/Nextcloud/sync-exclude.lst "$NEXTCLOUD_DIR" "$NEXTCLOUD_URL"; then
    notify-send -i "$NXTCDD_NOTIFY_ICON" -a "$NXTCDD_APP_NAME_NOTIFICATION" -u "critical"  "failed sync with $NEXTCLOUD_URL"
  else
    notify-send -i "$NXTCDD_NOTIFY_ICON" -a "$NXTCDD_APP_NAME_NOTIFICATION" -u "normal"  "done sync with $NEXTCLOUD_URL"

  fi
}

init(){
  read -p "input nextcloud username: " nextcloud_username
  echo "$nextcloud_username"| secret-tool store nextcloud-repository nextcloud_username --label="nextcloud username"
  read -p "input nextcloud password: " -s nextcloud_password
  echo "$nextcloud_password"| secret-tool store nextcloud-repository nextcloud_password --label="nextcloud password"
}

start(){
  if test ! -d "$NEXTCLOUD_DIR"; then mkdir -p "$NEXTCLOUD_DIR";fi
    nxt_sync
  inotifywait -m $NEXTCLOUD_DIR/* -e move -e move_self -e delete_self -e delete -e create -e close_write -e modify | while read file; do
    echo $file
    nxt_sync
  done
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
