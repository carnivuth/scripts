#!/bin/bash
# set rofi theme 
dir="$HOME/.config/rofi/filebrowser/"
theme='snorlax-line'
if [ "$#" -eq 1 ]; then 
    theme="$1"
fi
# get wirless connections 
# print rofi menu to user with possible options
# get option and run nmcli command
