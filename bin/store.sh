#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
if [[ -f /etc/os-release ]];then source /etc/os-release; fi

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
  case $ID in
    "arch")
      # check for aur flag and use yay to run command
      if [[ "$AUR" == "TRUE" ]] && [[ -x "$( which yay )" ]]; then
        yay -Slq | fzf  --preview "yay -Si {1}"  | xargs -ro yay -S
      else
        pacman -Slq | fzf  --preview "pacman -Si {1}"  | xargs -ro $SUDO pacman -S
      fi
      ;;
    "debian"|"ubuntu")
      # acky way to do the same as arch but with apt
      apt-cache -n search '.*' | awk -F ' - ' '{print $1}' | fzf  --preview "apt-cache show  {1}"  | xargs -ro $SUDO apt-get install
      ;;
  esac
}

remove(){
  case $ID in
    "arch")
      # check for aur flag and use yay to run command
      if [[ "$AUR" == "TRUE" ]] && [[ -x "$( which yay )" ]]; then
        yay -Qq | fzf  --preview "yay -Qi {1}"  | xargs -ro yay -Rns
      else
        pacman -Qq | fzf  --preview "pacman -Qi {1}"  | xargs -ro $SUDO pacman -Rns
      fi
      ;;
    "debian"|"ubuntu")
      dpkg -l | grep '^ii' | awk -F ' ' '{print $2}' | fzf  --preview "apt-cache show  {1}"  | xargs -ro $SUDO apt-get remove
      ;;
  esac
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
