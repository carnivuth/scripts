#!/bin/bash
# set rofi theme
dir="$HOME/.config/rofi/fileexplorer"
theme='snorlax-line'
if [ "$#" -gt 0 ]; then
	theme="$1"
fi

#prompt
prompt='file explorer'

#max history size
max_size=50

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
get_history_size(){
	 wc -l "$HOME"/scripts/rofi/fileexplorer/history  | cut -d" " -f1
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
if [[ -f "$curpath/$chosen" || -f "$chosen" ]]; then
	if [[ "$(get_history_size)" -gt $max_size ]];then 
		rm "$HOME"/scripts/rofi/fileexplorer/history
	fi
	case $chosen in
	/*)
		xdg-open "$chosen"
		;;
	*) 
		echo "$curpath/$chosen" >> "$HOME"/scripts/rofi/fileexplorer/history
		xdg-open "$curpath/$chosen"
		 ;;
	esac
fi
