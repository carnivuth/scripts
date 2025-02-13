#!/bin/bash
#mount remote storage with rclone
source "$HOME/.config/scripts/settings.sh"

declare -A FLAGS
FLAGS_STRING=''

declare -A COMMANDS
COMMANDS[mnt]="mount configure storage"
COMMANDS[umnt]="unmount configure storage"

check_remote(){
  if [[ "$( rclone listremotes | grep "$1")" == '' ]];then
    notify-send -a "$RCLONE_MOUNT_APP_NAME_NOTIFICATION" -u "critical" "mount: $1 is not configured! run 'rclone config'"
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
      notify-send -a "$RCLONE_MOUNT_APP_NAME_NOTIFICATION" -u "normal" "unmounted $mount"
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
      notify-send -a "$RCLONE_MOUNT_APP_NAME_NOTIFICATION" -u "normal" "mounted  $mount"
    fi
    sleep infinity
  done
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
