#!/bin/bash

# rofi cmd
run_rofi() {

	 rofi -dmenu 
}

# main
chosen="$(run_rofi)"
if [ "$chosen" != "" ]; then 
	firefox --new-window --search "$chosen"
fi
