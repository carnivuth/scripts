#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/notify.sh"

declare -A FLAGS
FLAGS_STRING='d:'
FLAGS[d]='NEXTCLOUD_DIR=${OPTARG}'
FLAGS_DESCRIPTIONS[d]='nextcloud directory to manage'

declare -A COMMANDS
COMMANDS[start]="start nextcloud sync daemon"
COMMANDS[nxt_sync]="run a single sync operation"
COMMANDS[restart_all]="restart all units of this daemon using systemd"
COMMANDS[status_all]="check status of all units of this daemon using systemd"

NEXTCLOUD_UNSYNCED_FOLDERS_FILE="$HOME/.config/Nextcloud/unsyncedfolders.conf"
NEXTCLOUD_PARAMS="-s --non-interactive --exclude $HOME/.config/Nextcloud/sync-exclude.lst"

APP_NAME="nextcloud sync daemon"
APP_ICON="/usr/share/icons/Papirus/16x16/apps/nextcloud.svg"

check(){
  if [[ -z $NXTCDD_USERNAME ]] || [[ -z $NXTCDD_PASSWORD ]]; then
    notify "critical"  "username or password are not set in config file"
    return 1
  fi
  if test -z $NEXTCLOUD_URL; then
    notify  "critical"  "remote url not set in config file"
    return 1
  fi
  return 0
}

nxt_sync(){
  check || exit 1

  if test -z $NEXTCLOUD_DIR; then echo "pass directory to sync with -d "; exit 1; fi

  username="$NXTCDD_USERNAME"
  password="$NXTCDD_PASSWORD"

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

function status_all(){
systemctl --user --all -q list-units nxtcdd* | awk -F' ' '{print $1}' | while read unit; do
  systemctl --user status $unit;
done
}

function restart_all(){
systemctl --user --all -q list-units nxtcdd* | awk -F' ' '{print $1}' | while read unit; do
  echo "restarting $unit"
  systemctl --user restart $unit;
done
}

function start(){

  if test -z $NEXTCLOUD_DIR; then echo "pass directory to sync with -d "; exit 1; fi


  if test ! -d "$HOME/$NEXTCLOUD_DIR"; then mkdir -p "$HOME/$NEXTCLOUD_DIR";fi

    nxt_sync
    inotifywait -r -m "$HOME/$NEXTCLOUD_DIR" --exclude "$(find .  -name '.git' -type d -printf '%P|')\.sync.*\.db.*|.*\.lock" -e move,create,delete,modify | while read file; do
    echo  "$file detected change in $NEXTCLOUD_DIR"
    notify "normal"  "$file detected change in $NEXTCLOUD_DIR"
    nxt_sync
  done
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
