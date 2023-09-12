#!/bin/bash
source $HOME/scripts/settings.sh
if [ -f "$SCRIPTS_HOME_FOLDER/borg/target.sh" ]; then
    source "$SCRIPTS_HOME_FOLDER/rofi/target.sh"
else
    TARGET="$HOME"
fi
## remember to add record on gnome keyring !! 
## echo "passphrase"| secret-tool store borg-repository repo-name --label="borg passphrase"

export BORG_PASSCOMMAND="secret-tool lookup borg-repository home"
borg create --info /storage/borg::Home-"$(date +%c)" $TARGET 2>> $SCRIPTS_LOGS_FOLDER/home_backup.logs >> $SCRIPTS_LOGS_FOLDER/home_backup.logs