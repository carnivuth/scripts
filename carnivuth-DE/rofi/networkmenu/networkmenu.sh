#!/bin/bash

# source files
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_HOME_FOLDER/rofi/networkmenu/notify.sh"
source "$SCRIPTS_HOME_FOLDER/rofi/networkmenu/rescanwifinetworks.sh"
source "$SCRIPTS_HOME_FOLDER/rofi/networkmenu/connect.sh"
source "$SCRIPTS_HOME_FOLDER/rofi/networkmenu/deleteconnection.sh"
source "$SCRIPTS_HOME_FOLDER/rofi/networkmenu/togglewifi.sh"
source "$SCRIPTS_HOME_FOLDER/rofi/networkmenu/togglenetwork.sh"
source "$SCRIPTS_LIBS_FOLDER/rofi_standard.sh"


rofi_theme_setup "$ROFI_CONFIG_FOLDER/networkmenu" "$1" 'network menu'

# options
# rescan wifi networks
# delete connetion
# toggle wifi
# toggle networking
options=('connect-to-network' 'rescan-wifi-networks' 'delete-connection' 'toggle-wifi' 'toggle-networking')



print_options() {
    echo -e "$(for opt in ${options[@]}; do echo "$opt"; done)" | rofi_cmd "$prompt"

}

# main
selected=$(print_options | xargs)

# if no option was selected exit
if [ "$selected" == '' ]; then exit 0; fi

case ${selected} in
${options[0]})
    # connect to network
    connect_to_network
    exit 0
    ;;
${options[1]})
    # rescan wifi networks
    rescan_wifi_networks
    exit 0
    ;;
${options[2]})
    # delete connetion
    delete_connection
    exit 0
    ;;
${options[3]})
    # toggle wifi
    toggle_wifi
    exit 0
    ;;
${options[4]})
    # disable networking
    toggle_network
    exit 0
    ;;
esac
