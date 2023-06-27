#!/usr/bin/bash

dir="$HOME/.config/rofi/launchproject"
theme='snorlax-line'
if [ "$#" -gt 0 ]; then
	prompt="open project with $1"
else
	prompt="open project with code"
fi

if [ "$#" -eq 2 ]; then
	theme="$2"
fi
#project folders
FOLDERS=("$HOME/universita" "$HOME/universita/fondamenti_intelligenza_artificiale" "$HOME/.themes" "$HOME" "$HOME/.config" "$HOME/universita/iss/iss_2023_matteo_longhi" "$HOME/universita/iss/iss_2023_matteo_longhi/projects" "$HOME/universita/iss/isslab23")

# rofi cmd
run_rofi() {

	if [ -f "${dir}/${theme}.rasi" ]; then
		echo -e "$(for dir in ${FOLDERS[@]}; do ls -d "$dir"/*/; done)" | rofi -dmenu -p "${prompt}" -theme ${dir}/${theme}.rasi
	else
		echo -e "$(for dir in ${FOLDERS[@]}; do ls -d "$dir"/*/; done)" | rofi -dmenu -p "${prompt}"

	fi
}
# main
chosen="$(run_rofi)"
echo $chosen
# open selected folder on $1 parameter default code
if [ -d "$chosen" ]; then
	if [ "$#" -eq 1 ]; then
		"$1" "$chosen"
	else
		code "$chosen"
	fi
fi
