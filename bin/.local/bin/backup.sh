#!/bin/bash

#make backups with borg
# this scripts creates backups using the borg program and sync the borg repository with rsync to a remote server,
# the script is meant to run with a systemd timer
source "$HOME/.config/scripts/settings.sh"


BORG_RESULT_FILE="$(mktemp)"

# check if borg repository is configured
check(){

  if [[ ! -d "$BORG_REPOSITORY_FOLDER" ]]; then
    notify-send -a "$BORG_APP_NAME_NOTIFICATION" -u "critical" -i "$BORG_NOTIFICATION_ICON" "borg repo at $BORG_REPOSITORY_FOLDER not initialized! run $0 init"
    exit 1
  fi

}
check_borg_is_running(){
  if [[ "$(pidof borg)" != "" ]]; then
    notify-send -a "$BORG_APP_NAME_NOTIFICATION" -u "normal" -i "$BORG_NOTIFICATION_ICON" "task $1 could not run cause borg is running"
    exit 1
  fi
}

# configure borg repo for future backups and add passphrase to user keyring
init(){

  check_borg_is_running "$0"
  # create repository folder if does not exists
  if [[ ! -d "$BORG_REPOSITORY_FOLDER" ]]; then
    mkdir -p "$BORG_REPOSITORY_FOLDER"

    echo -n "input borg repo passphrase:"
    read -s borg_passphrase
    echo "$borg_passphrase"| secret-tool store borg-repository borg_passphrase --label="borg repository passphrase"

    export BORG_PASSCOMMAND="secret-tool lookup borg-repository borg_passphrase"
    borg init --encryption repokey --make-parent-dirs "$BORG_REPOSITORY_FOLDER"
    unset BORG_PASSCOMMAND

  else
    echo "borg repo already initialized"
  fi

}

# make backup, check repo and sync to remotes
backup(){

  check
  check_borg_is_running "$0"

  # exporting borg command to retrive encription passphrase
  export BORG_PASSCOMMAND="secret-tool lookup borg-repository borg_passphrase"

  # making actual backups
  while read TARGET ;do
    NAME="$(echo "$TARGET" | rev | cut -d '/' -f 1 | rev)"
    borg create --info --stats --progress "$BORG_REPOSITORY_FOLDER::$NAME-$(date +%c)" "${TARGET}"  && BACKUPPED_TARGETS="${TARGET},$BACKUPPED_TARGETS"
  done <<<$(echo "$BORG_BACKUP_TARGETS")

  # check backup output for notifications
  if [[ "$BACKUPPED_TARGETS" != '' ]]; then

    notify-send -a "$BORG_APP_NAME_NOTIFICATION" -i "$BORG_NOTIFICATION_ICON" -u "normal" "done backup of $BACKUPPED_TARGETS in the $BORG_REPOSITORY_FOLDER borg repo"
  else

    notify-send -a "$BORG_APP_NAME_NOTIFICATION" -i "$BORG_NOTIFICATION_ICON" -u "critical" "no backup in $BORG_REPOSITORY_FOLDER borg repo has been made!"
  fi

  # check borg repo contents
  BORG_CHECK_RESULTS="$(borg check "$BORG_REPOSITORY_FOLDER")"

  if [[ "$BORG_CHECK_RESULTS" != '' ]]; then
    echo "$BORG_CHECK_RESULTS"
    notify-send -a "$BORG_APP_NAME_NOTIFICATION" -i "$BORG_NOTIFICATION_ICON" -u "critical" "repo $BORG_REPOSITORY_FOLDER is corrupted! check the unit status"
  else
    notify-send -a "$BORG_APP_NAME_NOTIFICATION" -i "$BORG_NOTIFICATION_ICON" -u "normal" "repo $BORG_REPOSITORY_FOLDER is healty :)"
  fi

  # try to sync with remote server
  if [ "$BORG_REMOTE_ENABLED" == 1 ] && ping -w 1 "$BORG_BACKUP_REMOTE_SERVER"; then

    # create directory
    ssh "$BORG_BACKUP_REMOTE_USER"@"$BORG_BACKUP_REMOTE_SERVER" mkdir -p "$BORG_BACKUP_REMOTE_PATH"

    if rsync -r "$BORG_REPOSITORY_FOLDER" "$BORG_BACKUP_REMOTE_USER"@"$BORG_BACKUP_REMOTE_SERVER":"$BORG_BACKUP_REMOTE_PATH"; then
      notify-send -a "$BORG_APP_NAME_NOTIFICATION" -i "$BORG_NOTIFICATION_ICON" -u "normal" "synced with remote $BORG_BACKUP_REMOTE_SERVER"
    else
      notify-send -a "$BORG_APP_NAME_NOTIFICATION" -i "$BORG_NOTIFICATION_ICON" -u "critical" "error in sincronization with remote $BORG_BACKUP_REMOTE_SERVER"
    fi

  fi

  # try to sync with rclone to remote storage
  if [ "$BORG_RCLONE_ENABLED" == 1 ]  ; then

    if [[ "$(rclone listremotes | grep "$BORG_RCLONE_REMOTE")" == '' ]]; then
      notify-send -a "$BORG_APP_NAME_NOTIFICATION" -i "$BORG_NOTIFICATION_ICON" -u "critical" "rclone storage $BORG_RCLONE_REMOTE not configured"
    else

      # create directory
      rclone mkdir "$BORG_RCLONE_REMOTE:$BORG_BACKUP_RCLONE_PATH"

      if rclone sync "$BORG_REPOSITORY_FOLDER" "$BORG_RCLONE_REMOTE:$BORG_BACKUP_RCLONE_PATH" ; then

        notify-send -a "$BORG_APP_NAME_NOTIFICATION" -i "$BORG_NOTIFICATION_ICON" -u "normal" "synced with rclone storage $BORG_RCLONE_REMOTE"
      else
        notify-send -a "$BORG_APP_NAME_NOTIFICATION" -i "$BORG_NOTIFICATION_ICON" -u "critical" "error in sincronization with rclone storage $BORG_RCLONE_REMOTE"
      fi
    fi

  fi

  # unset borg command
  unset BORG_PASSCOMMAND
}

# restore from rsync capable remote
restore_remote(){

  check_borg_is_running "$0"

  echo -n "input borg repo passphrase:"
  read -r -s borg_passphrase
  echo "$borg_passphrase"| secret-tool store borg-repository borg_passphrase --label="borg repository passphrase"

  # try to restore with remote server
  if  ping -w 1 "$BORG_BACKUP_REMOTE_SERVER"; then

    if rsync -r "$BORG_BACKUP_REMOTE_USER"@"$BORG_BACKUP_REMOTE_SERVER":"$BORG_BACKUP_REMOTE_PATH" "$BORG_REPOSITORY_FOLDER"; then
      notify-send -a "$BORG_APP_NAME_NOTIFICATION" -i "$BORG_NOTIFICATION_ICON" -u "normal" "restored repo from $BORG_BACKUP_REMOTE_SERVER"
    else
      notify-send -a "$BORG_APP_NAME_NOTIFICATION" -i "$BORG_NOTIFICATION_ICON" -u "critical" "error restoring repo from $BORG_BACKUP_REMOTE_SERVER"
    fi

  fi
}

# restore from rclone remote storage
restore_rclone(){
  check_borg_is_running "$0"
  # try to restore with rclone from remote storage

  echo -n "input borg repo passphrase:"
  read -r -s borg_passphrase
  echo "$borg_passphrase"| secret-tool store borg-repository borg_passphrase --label="borg repository passphrase"
  if [[ "$(rclone listremotes | grep "$BORG_RCLONE_REMOTE")" == '' ]]; then
    notify-send -a "$BORG_APP_NAME_NOTIFICATION" -i "$BORG_NOTIFICATION_ICON" -u "critical" "rclone storage $BORG_RCLONE_REMOTE not configured"
  else

    if rclone sync "$BORG_RCLONE_REMOTE:$BORG_BACKUP_RCLONE_PATH" "$BORG_REPOSITORY_FOLDER"  ; then

      notify-send -a "$BORG_APP_NAME_NOTIFICATION" -i "$BORG_NOTIFICATION_ICON" -u "normal" "restored repo from rclone storage $BORG_RCLONE_REMOTE"
    else
      notify-send -a "$BORG_APP_NAME_NOTIFICATION" -i "$BORG_NOTIFICATION_ICON" -u "critical" "error restoring repo with rclone storage $BORG_RCLONE_REMOTE"
    fi
  fi

}

prune(){
  check
  check_borg_is_running "$0"

  echo '0' > "$BORG_RESULT_FILE"

  export BORG_PASSCOMMAND="secret-tool lookup borg-repository borg_passphrase"

  while read -r TARGET ;do
    NAME="$(basename "$TARGET")"
    borg prune --list -m "$BORG_PRUNE_POLICY" -a "${NAME}*" "$BORG_REPOSITORY_FOLDER" || echo '1' > "$BORG_RESULT_FILE"
  done <<<$(echo "$BORG_BACKUP_TARGETS")
  borg compact "$BORG_REPOSITORY_FOLDER"

  # unset borg command
  unset BORG_PASSCOMMAND

  if [[ "$(cat "$BORG_RESULT_FILE")" == "0" ]]; then
    notify-send -a "$BORG_APP_NAME_NOTIFICATION" -i "$BORG_NOTIFICATION_ICON" -u "normal" "prune operation complete succesfully"
  else
    notify-send -a "$BORG_APP_NAME_NOTIFICATION" -i "$BORG_NOTIFICATION_ICON" -u "critical" "repos could not be pruned"
  fi


}

case "$1" in
  init)
    init
    ;;
  backup)
    backup
    ;;
  prune)
    prune
    ;;
  restore_rclone)
    restore_rclone
    ;;
  restore_remote)
    restore_remote
    ;;
  *)
    echo "usage $0 [init|backup|prune|restore_rclone|restore_remote]"
    ;;
esac
