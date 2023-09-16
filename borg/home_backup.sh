#!/bin/bash
#make backups with borg 
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/array_importer.sh"

array_importer "$SCRIPTS_HOME_FOLDER/borg/target.sh" "$HOME" 

#folder where backups are stored
BACKUP_FOLDER="/storage/borg"

## remember to add record on gnome keyring !! 
## echo "passphrase"| secret-tool store borg-repository repo-name --label="borg passphrase"

export BORG_PASSCOMMAND="secret-tool lookup borg-repository home"

for TARGET in ${ARRAY[@]}; do 
    NAME="$(echo $TARGET | rev | cut -d '/' -f 1 | rev)"
    borg create --info "$BACKUP_FOLDER::$NAME-$(date +%c)" "$TARGET" 2>> "$SCRIPTS_LOGS_FOLDER/home_backup.logs" >> "$SCRIPTS_LOGS_FOLDER/home_backup.logs" &
 done
