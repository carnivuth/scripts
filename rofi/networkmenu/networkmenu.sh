#!/bin/bash

# source files
source ~/scripts/rofi/networkmenu/notify.sh
source ~/scripts/rofi/networkmenu/rescanwifinetworks.sh
source ~/scripts/rofi/networkmenu/connect.sh
source ~/scripts/rofi/networkmenu/deleteconnection.sh
source ~/scripts/rofi/networkmenu/togglewifi.sh
source ~/scripts/rofi/networkmenu/togglenetwork.sh
# set rofi theme
dir="$HOME/.config/rofi/networkmenu/"
theme='snorlax-line'
if [ "$#" -eq 1 ]; then
    theme="$1"
fi

# prompts
prompt_options='Network Options'

# options
# rescan wifi networks
# delete connetion
# list connection
# toggle wifi
# toggle networking
options=('connect-to-network' 'rescan-wifi-networks' 'delete-connection' 'toggle-wifi' 'toggle-networking')

# Rofi CMD
rofi_cmd() {
    if [ -f "${dir}/${theme}.rasi" ]; then
        rofi -dmenu \
            -p "$1" \
            -theme ${dir}/${theme}.rasi
    else
        rofi -dmenu \
            -p "$1"

    fi
}

print_options() {
    echo -e "$(for opt in ${options[@]}; do echo "$opt"; done)" | rofi_cmd "${prompt_options}"

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
