toggle_wifi() {
    if [ "$(nmcli radio wifi)" == 'enabled' ]; then
        nmcli radio wifi off && notify normal "Wifi turned off" "Wifi successfully turned off"
    else
        nmcli radio wifi on && notify normal "Wifi turned on" "Wifi successfully turned on"
    fi
}
