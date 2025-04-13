#!/bin/bash
#mount remote storage with rclone
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/notify.sh"

APP_NAME="rclone mount"
APP_ICON="/usr/share/icons/Papirus/16x16/apps/disk-manager.svg"

declare -A FLAGS
FLAGS_STRING=''

declare -A COMMANDS
COMMANDS[mnt]="mount configure storage"
COMMANDS[umnt]="unmount configure storage"

check_remote(){
  if [[ "$( rclone listremotes | grep "$1")" == '' ]];then
    notify "critical" "mount: $1 is not configured! run 'rclone config'"
    return 1
  fi
  return 0
}

umnt(){
  for mount in "${!MOUNTS[@]}"; do

    path="${MOUNTS[$mount]}"

    #logs parameters
    echo "$mount"
    echo "$path"

    if check_remote "$mount" ; then
      umount "$path"
      notify "normal" "unmounted $mount"
    fi
  done
}

mnt(){
  for mount in "${!MOUNTS[@]}"; do

    path="${MOUNTS[$mount]}"

    #logs parameters
    echo "$mount"
    echo "$path"

    if check_remote "$mount" ; then
      mkdir -p "$path"
      rclone mount "$mount": "$path" --daemon
      notify "normal" "mounted  $mount"
    fi
    sleep infinity
  done
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
