#!/bin/bash
source "$HOME/scripts/settings.sh"

# SCRIPT SPECIFIC VARS AND FUNCTIONS
NETWORKMENU_APP_NAME_NOTIFICATION="networkmenu"

rescan_wifi_networks(){
  nmcli device wifi rescan && notify-send -a "$NETWORKMENU_APP_NAME_NOTIFICATION" -u "normal" "Rescan completed" "wifi networks rescan complete"
}

toggle_wifi() {
  if [ "$(nmcli radio wifi)" == 'enabled' ]; then
    nmcli radio wifi off && notify-send -a "$NETWORKMENU_APP_NAME_NOTIFICATION" -u "normal" "Wifi turned off" "Wifi successfully turned off"
  else
    nmcli radio wifi on && notify-send -a "$NETWORKMENU_APP_NAME_NOTIFICATION" -u "normal" "Wifi turned on" "Wifi successfully turned on"
  fi
}

toggle_networking() {
  if [ "$(nmcli network)" == 'enabled' ]; then
    nmcli network off && notify-send -a "$NETWORKMENU_APP_NAME_NOTIFICATION" -u "normal" "Network turned off" "Network successfully turned off"
  else
    nmcli network on && notify-send -a "$NETWORKMENU_APP_NAME_NOTIFICATION" -u "normal" "Network turned on" "Network successfully turned on"
  fi
}

# STANDARD MENU VARS AND FUNCTIONS
MENU_NAME="window_switcher"
PROMPT="window switcher"

help_message(){
  echo " script for interacting with network manager end editing connection settings"
  echo "usage $0 -c [connect|delete|rescan|toggle_wifi|toggle_networking]"
}

list_elements_to_user(){
  case "$NETWORKMENU_COMMAND" in
    'connect')
      nmcli -f ssid device wifi list -rescan no | grep -v SSID | grep -E -v '^--'
      ;;
    'delete')
      nmcli -f name connection | grep -v NAME
      ;;
  esac
}

exec_command_with_chosen_element(){
  case "$NETWORKMENU_COMMAND" in
    'connect')
      if [ "$(nmcli connection | grep "$1")" != "" ]; then
        nmcli device wifi connect "$1" && notify-send -a "$NETWORKMENU_APP_NAME_NOTIFICATION" -u "normal" "connected" "connected to $1"
      fi
      ;;
    'delete')
      # check if item is a valid connection
      if [ "$(nmcli -f name connection | grep "$1")" != "" ]; then
        nmcli connection delete "$1" && notify-send -a "$NETWORKMENU_APP_NAME_NOTIFICATION" -u "normal" "deleted" "$1 csuccesfully deleted"
      fi
      ;;
  esac
}


while getopts c:b:h flag; do
  case "${flag}" in
    c) NETWORKMENU_COMMAND=${OPTARG} ; shift; shift ;;
    *);;
  esac
done

case "$NETWORKMENU_COMMAND" in
  "connect")
    source "$SCRIPTS_LIB_FOLDER/menu.sh"
    exit 0
    ;;
  "delete")
    source "$SCRIPTS_LIB_FOLDER/menu.sh"
    exit 0
    ;;
  "rescan")
    rescan_wifi_networks
    exit 0
    ;;
  "toggle_wifi")
    toggle_wifi
    exit 0
    ;;
  "toggle_networking")
    toggle_networking
    exit 0
    ;;
esac
