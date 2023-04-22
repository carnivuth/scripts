#!/usr/bin/bash

dir="$HOME/.config/rofi/launchproject"
theme='snorlax-line'

#project folders
FOLDERS=( "/home/matteo/universita" "/home/matteo/.themes" "/home/matteo" "/home/matteo/.config" "/home/matteo/universita/iss/iss_2023_matteo_longhi" "/home/matteo/universita/iss/iss_2023_matteo_longhi/projects" "/home/matteo/universita/iss/isslab23" )


# rofi cmd
run_rofi() {

if [ -f "${dir}/${theme}.rasi"  ]; then
	echo -e "$(for dir in ${FOLDERS[@]}; do ls -d "$dir"/*/ ; done)" | rofi -dmenu -theme ${dir}/${theme}.rasi
else
	echo -e "$(for dir in ${FOLDERS[@]}; do ls -d "$dir"/*/ ; done)" | rofi -dmenu 

fi
}
# main
chosen="$(run_rofi)"
echo $chosen
# open selected folder on $1 parameter default code
if [ -d "$chosen"  ] ; then
	if [ "$#" -eq 1 ] ; then
		"$1" "$chosen"
	else
		code "$chosen"
	fi
fi