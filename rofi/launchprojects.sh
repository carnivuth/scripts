#!/usr/bin/bash

dir="$HOME/.config/rofi/launchproject"
theme='snorlax-line'

#!/bin/bash
#project folders
FOLDERS=( "/home/matteo/universita" "/home/matteo/.themes" "/home/matteo" "/home/matteo/.config" "/home/matteo/universita/iss/iss_2023_matteo_longhi" "/home/matteo/universita/iss/iss_2023_matteo_longhi/projects" "/home/matteo/universita/iss/isslab23" )

#wofi utilities
# Pass variables to wofi dmenu
run_rofi() {

	echo -e "$(for dir in ${FOLDERS[@]}; do ls -d "$dir"/*/ ; done)" | rofi -dmenu -theme ${dir}/${theme}.rasi
}
# show wofi with folders
chosen="$(run_rofi)"
echo $chosen
# open selected folder on IDE default code
if [ -d "$chosen"  ] ; then
	if [ "$#" -eq 1 ] ; then
		"$1" "$chosen"
	else
		code "$chosen"
	fi
fi