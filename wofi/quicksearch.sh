#!/bin/bash
#project folders
OPTIONS=( "Shutdown" "reboot" "sleep" "exit" "lock" )
#wofi utilities


# Pass variables to rofi dmenu
run_wofi() {

	 wofi --show dmenu --prompt='firefox search' --heigh="5%"
}
# show rofi with folders
chosen="$(run_wofi)"
if [ "$chosen" != "" ]; then 
	firefox --new-window --search "$chosen"
fi
