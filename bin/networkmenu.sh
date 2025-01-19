#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

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
MENU_NAME="networkmenu"
PROMPT="networks"

help_message(){
  echo "connect to known networks"
}

list_elements_to_user(){
      nmcli device wifi rescan; nmcli -f name connection | grep -v NAME
}

exec_command_with_chosen_element(){
      network="$(echo $1 | xargs)"
      if [ "$(nmcli connection | grep "$network")" != "" ]; then
        nmcli device wifi connect "$network" && notify-send -a "$NETWORKMENU_APP_NAME_NOTIFICATION" -u "normal" "connected" "connected to $network"
      fi
}

source "$SCRIPTS_LIB_FOLDER/menu.sh"
