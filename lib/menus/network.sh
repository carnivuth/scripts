#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/notify.sh"

function list_network(){
  nmcli device wifi rescan; nmcli -t -f name connection | sed 's/^/network:/g'
}

function exec_command_with_chosen_element(){
  network="$(echo $1 | xargs)"
  if [ "$(nmcli connection | grep "$network")" != "" ]; then
    nmcli device wifi connect "$network" && notify "normal" "connected to $network"
  fi
}
