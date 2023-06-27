#!/bin/bash
#project folders
FOLDERS=("$HOME/universita" "$HOME/.themes" "$HOME" "$HOME/.config" "$HOME/universita/iss/iss_2023_matteo_longhi" "$HOME/universita/iss/iss_2023_matteo_longhi/projects" "$HOME/universita/iss/isslab23")

#wofi utilities
# Pass variables to wofi dmenu
run_wofi() {

	echo -e "$(for dir in ${FOLDERS[@]}; do ls -d "$dir"/*/; done)" | wofi --show dmenu
}
# show wofi with folders
chosen="$(run_wofi)"
echo $chosen
# open selected folder on IDE default code
if [ -d "$chosen" ]; then
	if [ "$#" -gt 1 ]; then
		"$1" "$chosen"
	else
		code "$chosen"
	fi
fi
