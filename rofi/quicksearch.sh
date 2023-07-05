#!/bin/bash

# theme
dir="$HOME/.config/rofi/quicksearch"
theme='snorlax-line'

if [ "$#" -eq 1 ]; then
	theme="$1"
fi

# prompt colon
prompt='search with firefox'

# rofi cmd
run_rofi() {
	if [ -f "${dir}/${theme}.rasi" ]; then

		rofi -dmenu -p "$prompt" -theme ${dir}/${theme}.rasi
	else
		rofi -dmenu -p "$prompt"
	fi
}

# main
chosen="$(run_rofi)"
if [ "$chosen" != "" ]; then
	case "$chosen" in
	https*)
		xdg-open "$chosen"
		;;
	*) 
			firefox --new-window --search "$chosen"
		 ;;
	esac
fi
