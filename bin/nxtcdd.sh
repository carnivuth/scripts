#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/notify.sh"

declare -A FLAGS
FLAGS_STRING='d:'
FLAGS[d]='NEXTCLOUD_DIR=${OPTARG}'

declare -A COMMANDS
COMMANDS[start]="start nextcloud sync daemon daemon"
COMMANDS[init]="setup credentials in keyring"
COMMANDS[nxt_sync]="run a single sync operation"
COMMANDS[restart_all]="restart all units of this daemon using systemd"

NEXTCLOUD_UNSYNCED_FOLDERS_FILE="$HOME/.config/Nextcloud/unsyncedfolders.conf"
NEXTCLOUD_PARAMS="--non-interactive --exclude $HOME/.config/Nextcloud/sync-exclude.lst"

APP_NAME="nextcloud sync daemon"
APP_ICON="/usr/share/icons/Papirus/32x32/apps/nextcloud.svg"

check(){
  if ! secret-tool lookup nextcloud-repository nextcloud_username > /dev/null 2>&1 || ! secret-tool lookup nextcloud-repository nextcloud_password > /dev/null 2>&1; then
    notify "critical"  "username or password are not set in keyring"
    return 1
  fi
  # removed cause bug on nextcloudcmd command when running sql queries against excluded folder table?
  #if test ! -f "$NEXTCLOUD_UNSYNCED_FOLDERS_FILE"; then
  #  notify "critical"  "excluded folders configuration file does not exist"
  #  return 1
  #fi
  if test -z $NEXTCLOUD_URL; then
    notify  "critical"  "remote url not set in config file"
    return 1
  fi
  return 0
}

nxt_sync(){
  check || exit 1

  if test -z $NEXTCLOUD_DIR; then echo "pass directory to sync with -d "; exit 1; fi

  username="$(secret-tool lookup nextcloud-repository nextcloud_username)"
  password="$(secret-tool lookup nextcloud-repository nextcloud_password)"

  find "$HOME/$NEXTCLOUD_DIR" -regex ".*conflicted copy.*" -exec rm {} \;

    notify "normal"  "started sync from $NEXTCLOUD_URL to $NEXTCLOUD_DIR"
  if ! nextcloudcmd $NEXTCLOUD_PARAMS -u "$username" -p "$password"  --path "/$NEXTCLOUD_DIR" "$HOME/$NEXTCLOUD_DIR" "$NEXTCLOUD_URL"; then
    notify "critical"  "failed sync with $NEXTCLOUD_URL for $NEXTCLOUD_DIR"
  else
    notify "normal"  "done sync with $NEXTCLOUD_URL for $NEXTCLOUD_DIR"

  fi

  find "$HOME/$NEXTCLOUD_DIR" -regex ".*conflicted copy.*" -exec rm {} \;

  echo "sync finished"
}

init(){
  read -p "input nextcloud username: " nextcloud_username
  echo "$nextcloud_username"| secret-tool store nextcloud-repository nextcloud_username --label="nextcloud username"
  read -p "input nextcloud password: " -s nextcloud_password
  echo "$nextcloud_password"| secret-tool store nextcloud-repository nextcloud_password --label="nextcloud password"
}

function restart_all(){
systemctl --user -q list-units nxtcdd* | awk -F' ' '{print $1}' | while read unit; do
  echo "restarting $unit"
  systemctl --user restart $unit;
done
}

function start(){

  if test -z $NEXTCLOUD_DIR; then echo "pass directory to sync with -d "; exit 1; fi


  if test ! -d "$HOME/$NEXTCLOUD_DIR"; then mkdir -p "$HOME/$NEXTCLOUD_DIR";fi

    nxt_sync
  inotifywait -m "$HOME/$NEXTCLOUD_DIR" --exclude ".sync.*" -e move,create,delete,modify | while read file; do
    echo $file
    nxt_sync
  done
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
