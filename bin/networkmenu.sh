#!/bin/bash

# source files
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER"/"$MENU_BACKEND"_standard.sh

NETWORKMENU_APP_NAME_NOTIFICATION="networkmenu"
NETWORKMENU_PROMPT="networkmenu"
OPTIONS=('connect-to-network' 'rescan-wifi-networks' 'delete-connection' 'toggle-wifi' 'toggle-networking')

menu_theme_setup networkmenu
# print menu to ask for password
ask_password() {
  menu_cmd "$NETWORKMENU_PROMPT"
}

# print network list
print_networks() {
  echo -e "$(nmcli -f ssid device wifi list -rescan no | grep -v SSID | grep -E -v '^--')" | menu_cmd "$NETWORKMENU_PROMPT"
}

# print connection list
print_connections() {
  echo -e "$(nmcli -f name connection | grep -v NAME)" | menu_cmd "$NETWORKMENU_PROMPT"
}

print_options() {
  echo -e "$(for opt in "${OPTIONS[@]}"; do echo "$opt"; done)" | menu_cmd "$NETWORKMENU_PROMPT"
}

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

toggle_network() {
  if [ "$(nmcli network)" == 'enabled' ]; then
    nmcli network off && notify-send -a "$NETWORKMENU_APP_NAME_NOTIFICATION" -u "normal" "Network turned off" "Network successfully turned off"
  else
    nmcli network on && notify-send -a "$NETWORKMENU_APP_NAME_NOTIFICATION" -u "normal" "Network turned on" "Network successfully turned on"
  fi
}

connect_to_network() {
  network=$(print_networks | xargs)

    # connect to network
    if [ "$(nmcli connection | grep "$network")" != "" ]; then

      nmcli device wifi connect "$network" && notify-send -a "$NETWORKMENU_APP_NAME_NOTIFICATION" -u "normal" "connected" "connected to $network"

    elif [ "$(nmcli -f ssid device wifi list -rescan no | grep "$network")" != '' ]; then

        #ask for network password
        password=$(ask_password)
        #check for empty password
        if [ "$password" == '' ]; then exit 0; fi

        nmcli device wifi connect "$network" password "$password" && notify-send -a "$NETWORKMENU_APP_NAME_NOTIFICATION" -u "normal" "connected" "connected to $network"

    fi
  }


  delete_connection() {
    conneciton=$(print_connections | xargs)

    # check if item is a valid connection
    if [ "$(nmcli -f name connection | grep "$conneciton")" != "" ]; then

      nmcli connection delete "$conneciton" && notify-send -a "$NETWORKMENU_APP_NAME_NOTIFICATION" -u "normal" "deleted" "$conneciton succesfully deleted"
    fi
  }


  selected=$(print_options | xargs)

# if no option was selected exit
if [ "$selected" == '' ]; then exit 0; fi

case ${selected} in
  "${OPTIONS[0]}")
    # connect to network
    connect_to_network
    exit 0
    ;;
  "${OPTIONS[1]}")
    # rescan wifi networks
    rescan_wifi_networks
    exit 0
    ;;
  "${OPTIONS[2]}")
    # delete connetion
    delete_connection
    exit 0
    ;;
  "${OPTIONS[3]}")
    # toggle wifi
    toggle_wifi
    exit 0
    ;;
  "${OPTIONS[4]}")
    # disable networking
    toggle_network
    exit 0
    ;;
esac
