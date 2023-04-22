#!/bin/bash
# theme
dir="$HOME/.config/rofi/quicksearch"
theme='snorlax-line'
# prompt colon
prompt= 'browse with firefox'
# rofi cmd
run_rofi() {

	 rofi -dmenu -p "$prompt" -theme ${dir}/${theme}.rasi
}

# main
chosen="$(run_rofi)"
if [ "$chosen" != "" ]; then 
	firefox --new-window --search "$chosen"
fi
