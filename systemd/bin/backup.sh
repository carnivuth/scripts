#!/bin/bash

#make backups with borg 
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
  
  echo "$BORG_BACKUP_TARGETS" | while read TARGET ;do 
    NAME="$(echo $TARGET | rev | cut -d '/' -f 1 | rev)"
    borg create --info --stats --progress "$BORG_REPOSITORY_FOLDER::$NAME-$(date +%c)" "${TARGET}"  && \
    notify-send -a "Backup job" -u "normal" "done backup of $TARGET in the $BORG_REPOSITORY_FOLDER borg repo"
  done
  
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
