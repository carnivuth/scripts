#!/bin/bash
# source files
source ~/scripts/rofi/networkmenu/notify.sh
# set rofi theme 
dir="$HOME/.config/rofi/networkmenu/"
theme='snorlax-line'
if [ "$#" -eq 1 ]; then 
    theme="$1"
fi

# prompts
prompt='Networks'
prompt_pwd='Password'

# Rofi CMD
rofi_cmd() {
	if [ -f "${dir}/${theme}.rasi"  ]; then
		rofi -dmenu \
        -p "$1" \
			-theme ${dir}/${theme}.rasi
	else
		rofi -dmenu \
        -p "$1"
	
	fi
}

# print rofi menu to user with possible options
print_networks() {
	 echo -e "$(nmcli -f ssid device wifi list -rescan no| grep -v SSID)" | rofi_cmd ${prompt}
}

# print rofi menu to ask for password
ask_password(){
    rofi_cmd ${prompt_pwd}
}



# main
selected=$(print_networks| xargs)

# if no network was selected exit
if [ "$selected" == '' ]; then exit 0; fi

# connect to network
if [ "$(nmcli connection | grep "$selected")" != "" ]; then

    nmcli device wifi connect "$selected" && notify normal "connected" "connected to $selected"

elif [ "$(nmcli -f ssid device wifi list -rescan no | grep "$selected" )" != '' ]; then 
    
    #ask for network password
    password=$(ask_password)
    #check for empty password
    if [ "$password" == '' ]; then exit 0; fi

    nmcli device wifi connect "$selected" password "$password" && notify normal "connected" "connected to $selected"

fi

# options
# disable networking
# disable bluetooth
# disable wifi
# list connection 
# delete connetion
# rescan wifi networks
