toggle_network() {
    if [ "$(nmcli network)" == 'enabled' ]; then
        nmcli network off && notify normal "Network turned off" "Network successfully turned off"
    else
        nmcli network on && notify normal "Network turned on" "Network successfully turned on"
    fi
}
