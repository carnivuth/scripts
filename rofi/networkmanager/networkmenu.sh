#!/bin/bash

# set rofi theme 
dir="$HOME/.config/rofi/network-menu/"
theme='snorlax-line'
if [ "$#" -eq 1 ]; then 
    theme="$1"
fi

# prompt
prompt='Networks'

# Rofi CMD
rofi_cmd() {
	if [ -f "${dir}/${theme}.rasi"  ]; then
		rofi -dmenu \
        -p "${prompt}" \
			-theme ${dir}/${theme}.rasi
	else
		rofi -dmenu \
        -p "${prompt}"
	
	fi
}

# print rofi menu to user with possible options
print_networks() {
	 echo -e "$(nmcli -f ssid device wifi list | grep -v SSID)" | rofi_cmd
}

# main
selected=$(print_networks| xargs)

# if no network was selected exit
if [ "$selected" == '' ]; then exit 0; fi

# connect to network
if [ "$(nmcli connection | grep "$selected")" != "" ]; then

    nmcli device wifi connect "$selected"

elif [ "$(nmcli -f ssid device wifi list -rescan no | grep "$selected" )" != '']; then 
    
    #ask for network password
    password=$(rofi_cmd)
    nmcli device wifi connect "$selected" password "$password"

fi
