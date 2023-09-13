#!/usr/bin/bash

source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/array_importer.sh"

dir="$ROFI_CONFIG_FOLDER/launchproject"
theme="$DEFAULT_THEME"
if [ "$#" -gt 0 ]; then
	prompt="open project with $1"
else
	prompt="open project with code"
fi

if [ "$#" -eq 2 ]; then
	theme="$2"
fi

#import values from array
array_importer "$SCRIPTS_HOME_FOLDER/rofi/launchprojects/folders.sh" "$HOME"


# rofi cmd
run_rofi() {

	if [ -f "${dir}/${theme}.rasi" ]; then
		echo -e "$(for dir in ${ARRAY[@]}; do ls -d "$dir"/*/; done)" | rofi -dmenu -p "${prompt}" -theme ${dir}/${theme}.rasi
	else
		echo -e "$(for dir in ${ARRAY[@]}; do ls -d "$dir"/*/; done)" | rofi -dmenu -p "${prompt}"

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
