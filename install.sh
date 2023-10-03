#!/bin/bash
cp settings.sh.sample setting.sh
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