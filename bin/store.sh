#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

declare -A FLAGS
FLAGS_STRING='u'
FLAGS['u']="AUR=TRUE"

declare -A COMMANDS
COMMANDS[install]="install a package from repo"
COMMANDS[remove]="remove a package and orphans deps"

if [[ "$(whoami)" != 'root' ]];then
  SUDO="sudo"
fi

install(){
  # check for aur flag and use yay to run command
  if [[ "$AUR" == "TRUE" ]] && [[ -x "$( which yay )" ]]; then
    yay -Slq | fzf  --preview "yay -Si {1}"  | xargs -ro yay -S
  else
    pacman -Slq | fzf  --preview "pacman -Si {1}"  | xargs -ro $SUDO pacman -S
  fi
}

remove(){
  # check for aur flag and use yay to run command
  if [[ "$AUR" == "TRUE" ]] && [[ -x "$( which yay )" ]]; then
    yay -Qq | fzf  --preview "yay -Qi {1}"  | xargs -ro yay -Rns
  else
    pacman -Qq | fzf  --preview "pacman -Qi {1}"  | xargs -ro $SUDO pacman -Rns
  fi
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
