#!/bin/bash
#project folders
OPTIONS=( "Shutdown" "reboot" "sleep" "exit" "lock" )
#wofi utilities


# Pass variables to rofi dmenu
run_wofi() {

	echo -e "$(for OPTION in ${OPTIONS[@]}; do echo $OPTION  ; done)" | wofi --show dmenu
}
# show rofi with folders
chosen="$(run_wofi)"
if [  "$chosen" == "shutdown"  ]; then
	systemctl shutdown
fi
if [  "$chosen" == "reboot"  ]; then
	systemctl reboot
fi
if [  "$chosen" == "sleep"  ]; then
	echo "$chosen"
fi
if [  "$chosen" == "lock"  ]; then
	echo "$chosen"

fi
if [  "$chosen" == "exit"  ]; then
	echo "$chosen"

fi
