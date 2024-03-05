#!/bin/bash

## check on settings.sh file
if [[ ! -f "$HOME/scripts/settings.sh" ]]; then 
    echo 'no settings.sh file found, run: '
    echo "cp $HOME/scripts/settings.sh.sample $HOME/scripts/settings.sh"
    echo 'and edit the variables as you like'
    exit 1
fi 

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
echo 'install systemd files?[y/N]'
read answer
if [[  "$answer" == 'y' ]]; then
  source $SCRIPTS_HOME_FOLDER/systemd/install.sh
fi

# install DE
echo 'install utils?[Y/n]'
read answer

if [[  "$answer" == 'Y' || "$answer" == '' ]]; then
  source $SCRIPTS_HOME_FOLDER/utilities/install.sh
fi
