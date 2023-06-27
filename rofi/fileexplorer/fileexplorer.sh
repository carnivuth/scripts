#!/bin/bash
# set rofi theme
dir="$HOME/.config/rofi/fileexplorer"
theme='snorlax-line'
if [ "$#" -gt 0 ]; then
	theme="$1"
fi

#prompt
prompt='file explorer'

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
get_history(){
	cat "$HOME"/scripts/rofi/fileexplorer/history |uniq | tail -n5 
}

print_contents() {
	{ get_history; ls "$1";  } | rofi_cmd "${prompt}"

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
	echo "$curpath/$chosen" >> "$HOME"/scripts/rofi/fileexplorer/history
	xdg-open "$curpath/$chosen"
fi
