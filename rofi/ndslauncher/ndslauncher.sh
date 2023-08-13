#!/usr/bin/bash

dir="$HOME/.config/rofi/ndslauncher"
theme='snorlax-line'

prompt="open nds games with desmume"

if [ "$#" -eq 1 ]; then
	theme="$1"
fi
#project folders
if [ -f "$HOME/scripts/rofi/ndslauncher/folders.sh" ]; then
	source "$HOME/scripts/rofi/ndslauncher/folders.sh"
else
	FOLDER="$HOME"
fi

# rofi cmd
run_rofi() {

	if [ -f "${dir}/${theme}.rasi" ]; then
		echo -e "$(ls  "$FOLDER"/)" | rev| cut -d'.' -f2- | rev  |rofi -dmenu -p "${prompt}" -theme ${dir}/${theme}.rasi
	else
		echo -e "$( ls  "$FOLDER"/)" |rev| cut -d'.' -f2- | rev | rofi -dmenu -p "${prompt}"

	fi
}
# main
chosen="$(run_rofi)"
echo $chosen
# open selected folder on $1 parameter default code
if [ -f "$FOLDER/$chosen.nds" ]; then
	desmume "$FOLDER/$chosen.nds" &

fi
