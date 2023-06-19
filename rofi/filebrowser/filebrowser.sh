#!/bin/bash
# set rofi theme
dir="$HOME/.config/rofi/filebrowser"
theme='snorlax-line'

#prompt
prompt='file browser'
if [ "$#" -gt 1 ]; then
	theme="$1"
fi
rofi_cmd() {
	if [ -f "${dir}/${theme}.rasi" ]; then
		rofi -dmenu \
			-p "$1" \
			-theme ${dir}/${theme}.rasi
	else
		rofi -dmenu \
			-p "$1"

	fi
}

print_contents() {
	ls "$1" | rofi_cmd "${prompt}"

}

#main
curpath="$HOME"
chosen="$(print_contents "$HOME")"
#cicle inside directory
while [[ -d "$curpath/$chosen" && "$chosen" != '' ]]; do
	curpath="$curpath/$chosen"
	chosen="$(print_contents "$curpath")"
done
#open file
if [[ -f "$curpath/$chosen" ]]; then
	xdg-open "$curpath/$chosen"
fi
