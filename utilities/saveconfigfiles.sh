#!/bin/bash
# documentation at https://github.com/carnivuth/scripts/blob/main/notes/pages/SAVECONFIGFILES.md
source "$HOME/scripts/settings.sh"
timestamp="$(date +%s)"

mkdir -p "$SCRIPTS_RUN_FOLDER/config.backup.config.$timestamp"
mkdir -p "$SCRIPTS_RUN_FOLDER/config.backup.home.$timestamp"
mkdir -p "$SCRIPTS_RUN_FOLDER/config.backup.system.$timestamp"

echo "$config_files"|while read SOURCE; do
echo "coping $SOURCE"
cp -r "${SOURCE}" "$SCRIPTS_RUN_FOLDER/config.backup.config.$timestamp"
done
echo "$system_files" |while read SOURCE ; do
echo "coping $SOURCE" 
cp -r "$SOURCE" "$SCRIPTS_RUN_FOLDER/config.backup.system.$timestamp"
done
echo "$home_files" |while read SOURCE ; do
echo "coping $SOURCE"
cp -r "$SOURCE" "$SCRIPTS_RUN_FOLDER/config.backup.home.$timestamp"
done
tar -cvzf "$SCRIPTS_LOCAL_FOLDER/configs.$timestamp.tar.gz"   -C "$SCRIPTS_RUN_FOLDER" "config.backup.home.$timestamp" "config.backup.system.$timestamp" "config.backup.config.$timestamp"

echo "created archive configs.$timestamp.tar.gz in $SCRIPTS_LOCAL_FOLDER"
