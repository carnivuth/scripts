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
#echo "update pkgs list"
##remove old files
#rm archinstall_files/pacman_pkg.json
#rm archinstall_files/other_packets.json
##create pacman's pkgs file
#echo "\"packages\":[">>archinstall_files/tmp.json
#pacman -Qen | cut -d ' ' -f1 | while read PKG; do 
# echo "\"$PKG\",">>archinstall_files/tmp.json
#done 
#sed '$ s/.$//' archinstall_files/tmp.json > archinstall_files/pacman_pkg.json 
#rm archinstall_files/tmp.json
#echo "]">>archinstall_files/pacman_pkg.json
### launch cpp to resolve include statements
#cpp -P archinstall_files/user_configuration.template -o archinstall_files/user_configuration.json
##create other pkgs file
#pacman -Qem | cut -d ' ' -f1 | while read PKG; do 
# echo "\"$PKG\",">>archinstall_files/other_packets.json
#done