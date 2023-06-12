#prompt
prompt_networks='Networks'
prompt_pwd='Password'

# print rofi menu to ask for password
ask_password() {
    rofi_cmd ${prompt_pwd}
}

# print network list
print_networks() {
    echo -e "$(nmcli -f ssid device wifi list -rescan no | grep -v SSID | grep -E -v '^--')" | rofi_cmd ${prompt_networks}
}

connect_to_network() {
    network=$(print_networks | xargs)

    # connect to network
    if [ "$(nmcli connection | grep "$network")" != "" ]; then

        nmcli device wifi connect "$network" && notify normal "connected" "connected to $network"

    elif [ "$(nmcli -f ssid device wifi list -rescan no | grep "$network")" != '' ]; then

        #ask for network password
        password=$(ask_password)
        #check for empty password
        if [ "$password" == '' ]; then exit 0; fi

        nmcli device wifi connect "$network" password "$password" && notify normal "connected" "connected to $network"

    fi
}
