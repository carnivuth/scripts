#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/notify.sh"

APP_NAME="network"
APP_ICON="/usr/share/icons/Papirus/16x16/apps/gnome-networktool.svg"

function list_network(){
  nmcli device wifi rescan;
  nmcli -t -f name connection show --active | sed 's/^/network:/g'
}

function run_network(){
  network="$1"
  if [ "$(nmcli connection | grep "$network")" != "" ]; then
    nmcli device wifi rescan
    nmcli device wifi connect "$network" && notify "normal" "connected to $network" || notify "critical" "failed to connect to $network"
  fi
}
