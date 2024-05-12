#!/bin/bash

#make backups with borg 
# this scripts creates backups using the borg program and sync the borg repository with rsync to a remote server, the script is meant to run with a systemd timer
source "$HOME/scripts/settings.sh"

init(){
  
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

## remember to add record on gnome keyring !! 
## echo "passphrase"| secret-tool store borg-repository repo-name --label="borg passphrase"

backup(){

  if [[ ! -d "$BORG_REPOSITORY_FOLDER" ]]; then
    notify-send -a "Backup job" -u "critical" "borg repo at $BORG_REPOSITORY_FOLDER not initialized! run $0 init"
    exit 1
  fi

  # exporting borg command to retrive encription passphrase
  export BORG_PASSCOMMAND="secret-tool lookup borg-repository borg_passphrase"
  
  # making actual backups
  while read TARGET ;do 
    NAME="$(echo $TARGET | rev | cut -d '/' -f 1 | rev)"
    borg create --info --stats --progress "$BORG_REPOSITORY_FOLDER::$NAME-$(date +%c)" "${TARGET}"  && BACKUPPED_TARGETS="${TARGET},$BACKUPPED_TARGETS"
  done <<<$(echo "$BORG_BACKUP_TARGETS")

  # check backup output for notifications
  if [[ "$BACKUPPED_TARGETS" != '' ]]; then
    
    notify-send -a "Backup job" -u "normal" "done backup of $BACKUPPED_TARGETS in the $BORG_REPOSITORY_FOLDER borg repo"
  else

    notify-send -a "Backup job" -u "critical" "no backup in $BORG_REPOSITORY_FOLDER borg repo has been made!"
  fi

  # check borg repo contents
  BORG_CHECK_RESULTS="$(borg check "$BORG_REPOSITORY_FOLDER")"
  if [[ "$BORG_CHECK_RESULTS" != '' ]]; then
    echo "$BORG_CHECK_RESULTS"
    notify-send -a "Backup job" -u "critical" "repo $BORG_REPOSITORY_FOLDER is corrupted! check the unit status"
  else
    notify-send -a "Backup job" -u "normal" "repo $BORG_REPOSITORY_FOLDER is healty :)"
  fi


  # try to sync with remote server
  if [ "$BORG_REMOTE_ENABLED" == 1 ] && ping -w 1 "$BORG_BACKUP_REMOTE_SERVER"; then

    rsync -r $BORG_REPOSITORY_FOLDER "$BORG_BACKUP_REMOTE_USER"@"$BORG_BACKUP_REMOTE_SERVER":"$BORG_BACKUP_REMOTE_PATH"
    notify-send -a "Backup job" -u "normal" "synced with remote $BORG_BACKUP_REMOTE_SERVER"

  fi
  
  # unset borg command
  unset BORG_PASSCOMMAND
}

case "$1" in
  init)
    init
    ;;
  backup)
    backup
    ;;
  *)
    echo "usage $0 [init|backup]"
    ;;
esac
