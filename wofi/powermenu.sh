#!/bin/bash
#power options
OPTIONS=( "shutdown" "reboot" "sleep" "exit" "lock" )

# wofi command
run_wofi() {

	echo -e "$(for OPTION in ${OPTIONS[@]}; do echo $OPTION  ; done)" | wofi --show dmenu
}
# main
chosen="$(run_wofi)"
if [  "$chosen" == "shutdown"  ]; then
	systemctl poweroff
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
