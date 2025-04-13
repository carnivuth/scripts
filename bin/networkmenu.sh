#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/notify.sh"

declare -A FLAGS
FLAGS_STRING='b:'
FLAGS[b]='MENU_BACKEND=${OPTARG}'

declare -A COMMANDS
COMMANDS[rescan]="rescan wifi networks"
COMMANDS[wifi]="toggle wifi"
COMMANDS[network]="toggle networking"
COMMANDS[connect]="connect to a network"

APP_NAME="networkmenu"
APP_ICON="/usr/share/icons/Papirus/16x16/apps/gnome-networktool.svg"
MENU_NAME="networkmenu"
PROMPT="networks"

function rescan(){
  nmcli device wifi rescan && notify "normal" "Rescan completed"
}

function wifi() {
  if [ "$(nmcli radio wifi)" == 'enabled' ]; then
    nmcli radio wifi off && notify "normal" "Wifi turned off"
  else
    nmcli radio wifi on && notify "normal" "Wifi turned on"
  fi
}

function network() {
  if [ "$(nmcli network)" == 'enabled' ]; then
    nmcli network off && notify "normal" "Network turned off"
  else
    nmcli network on && notify "normal" "Network turned on"
  fi
}

function connect(){
  function help_message(){
    echo " connect to a network"
  }
  function list_elements_to_user(){
        nmcli device wifi rescan; nmcli -f name connection | grep -v NAME
  }

  function exec_command_with_chosen_element(){
        network="$(echo $1 | xargs)"
        if [ "$(nmcli connection | grep "$network")" != "" ]; then
          nmcli device wifi connect "$network" && notify "normal" "connected to $network"
        fi
  }

  source "$SCRIPTS_LIB_FOLDER/menu.sh"
}
source "$SCRIPTS_LIB_FOLDER/cli.sh"
