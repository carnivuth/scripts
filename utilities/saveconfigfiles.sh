#!/bin/bash
source "$HOME/scripts/settings.sh"
timestamp="$(date +%s)"

mkdir -p "$SCRIPTS_RUN_FOLDER/config.backup.config.$timestamp"
mkdir -p "$SCRIPTS_RUN_FOLDER/config.backup.home.$timestamp"
mkdir -p "$SCRIPTS_RUN_FOLDER/config.backup.system.$timestamp"

cat  $SCRIPTS_HOME_FOLDER/utilities/backup-files/configfiles |while read SOURCE; do
echo "coping $SOURCE"
cp -r "$SOURCE" "$SCRIPTS_RUN_FOLDER/config.backup.config.$timestamp"
done
cat $SCRIPTS_HOME_FOLDER/utilities/backup-files/systemfiles |while read SOURCE ; do
echo "coping $SOURCE" to 
cp -r "$SOURCE" "$SCRIPTS_RUN_FOLDER/config.backup.system.$timestamp"
done
cat $SCRIPTS_HOME_FOLDER/utilities/backup-files/homefiles |while read SOURCE ; do
echo "coping $SOURCE" to 
cp -r "$SOURCE" "$SCRIPTS_RUN_FOLDER/config.backup.home.$timestamp"
done
tar -cvzf "$SCRIPTS_LOCAL_FOLDER/configs.$timestamp.tar.gz"   -C "$SCRIPTS_RUN_FOLDER" "config.backup.home.$timestamp" "config.backup.system.$timestamp" "config.backup.config.$timestamp"