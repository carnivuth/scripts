#!/bin/bash
cp settings.sh.sample settings.sh
source "$HOME/scripts/settings.sh"

# install DE
echo 'install carnivuth-DE?[Y/n]'
unset answer

read answer
if [[  "$answer" == 'Y' || "$answer" == '' ]]; then
source $SCRIPTS_HOME_FOLDER/carnivuth-DE/install.sh
fi

# install DE
echo 'install desktop files?[Y/n]'
read answer
if [[  "$answer" == 'Y' || "$answer" == '' ]]; then
source $SCRIPTS_HOME_FOLDER/desktop-files/install.sh
fi

# install DE
echo 'install systemd files?[Y/n]'
read answer
if [[  "$answer" == 'Y' || "$answer" == '' ]]; then
source $SCRIPTS_HOME_FOLDER/systemd/install.sh
fi

# install DE
echo 'install utils?[Y/n]'
read answer
if [[  "$answer" == 'Y' || "$answer" == '' ]]; then
source $SCRIPTS_HOME_FOLDER/utilities/install.sh
fi

SAMPLE_FILES=( "$SCRIPTS_HOME_FOLDER/systemd/scripts/rclone-mounts.json" "$SCRIPTS_HOME_FOLDER/utilities/vaults" "$SCRIPTS_HOME_FOLDER/carnivuth-DE/rofi/github-repoviewer/account.sh" "$SCRIPTS_HOME_FOLDER/carnivuth-DE/rofi/musicplayer/folders.sh" "$SCRIPTS_HOME_FOLDER/carnivuth-DE/rofi/launchprojects/folders.sh" "$SCRIPTS_HOME_FOLDER/carnivuth-DE/rofi/themeswitcher/folders.sh" "$SCRIPTS_HOME_FOLDER/carnivuth-DE/rofi/vaultlauncher/folders.sh" "$SCRIPTS_HOME_FOLDER/systemd/scripts/target.sh" "$SCRIPTS_HOME_FOLDER/utilities/backup-files/configfiles" "$SCRIPTS_HOME_FOLDER/utilities/backup-files/systemfiles" "$SCRIPTS_HOME_FOLDER/utilities/backup-files/homefiles") 

# install DE
echo 'copying sample files'
for file in ${SAMPLE_FILES[@]}; do 
    if [[ ! -f "$file" ]];then
        echo 'copying $file'
        cp  "$file.sample"  "$file" 
    fi
done
