#!/bin/bash

#mount remote storage with rclone
source "$HOME/.config/scripts/settings.sh"

help_command(){
        echo "usage $0 [mount|umount]"
}

check_remote(){
  if [[ "$( rclone listremotes | grep "$1")" == '' ]];then
    notify-send -a "$RCLONE_MOUNT_APP_NAME_NOTIFICATION" -u "critical" "mount: $1 is not configured! run 'rclone config'"
    return 1
  fi
  return 0
}

umount_command(){
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

mount_command(){
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

case "$1" in
  "umount")
    umount_command
    ;;
  "mount")
    mount_command
    ;;
  *)
    help_command
    ;;
esac
