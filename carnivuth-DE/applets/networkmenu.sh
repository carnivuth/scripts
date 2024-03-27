#!/bin/bash

# source files
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_HOME_FOLDER/carnivuth-DE/applets/notify.sh"
source "$SCRIPTS_HOME_FOLDER/carnivuth-DE/applets/rescanwifinetworks.sh"
source "$SCRIPTS_HOME_FOLDER/carnivuth-DE/applets/connect.sh"
source "$SCRIPTS_HOME_FOLDER/carnivuth-DE/applets/deleteconnection.sh"
source "$SCRIPTS_HOME_FOLDER/carnivuth-DE/applets/togglewifi.sh"
source "$SCRIPTS_HOME_FOLDER/carnivuth-DE/applets/togglenetwork.sh"
source "$SCRIPTS_LIBS_FOLDER"/"$MENU_BACKEND"_standard.sh


menu_theme_setup networkmenu

# options
# rescan wifi networks
# delete connetion
# toggle wifi
# toggle networking
options=('connect-to-network' 'rescan-wifi-networks' 'delete-connection' 'toggle-wifi' 'toggle-networking')



print_options() {
    echo -e "$(for opt in ${options[@]}; do echo "$opt"; done)" | menu_cmd "$prompt"

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
