#!/usr/bin/bash

# Current Theme
dir="$HOME/.config/rofi/quicklinks"
theme='snorlax-line'

if [ "$#" -eq 1 ]; then 
    theme="$1"
fi

# Theme Elements
prompt='Quick Links'

# Options
#options=( "" "" "" "" "" "" "" "pokemon-showdown")
options=( "Youtube" "Github" "Reddit" "Virtuale" "Whatsapp" "Google-Drive" "Prolog-Engine" "Pokemon-Showdown")

# Rofi CMD
rofi_cmd() {
	if [ -f "${dir}/${theme}.rasi"  ]; then

		rofi -dmenu \
			-p "$prompt" \
			-markup-rows \
			-theme ${dir}/${theme}.rasi
	else
		rofi -dmenu \
			-p "$prompt" \
			-markup-rows \

	fi
}

# Pass variables to rofi dmenu
run_rofi() {
	 echo -e "$(for opt in ${options[@]}; do echo "$opt"; done )" | rofi_cmd
}

# Execute Command
run_cmd() {
	# youtube
	if [[ "$1" == "${options[0]}" ]]; then
		firefox --new-window 'https://www.youtube.com/' &
	# github
	elif [[ "$1" == "${options[1]}" ]]; then
		firefox --new-window 'https://www.github.com/' &
	# reddit
	elif [[ "$1" == "${options[2]}" ]]; then
		firefox --new-window 'https://www.reddit.com/' &
	# virtuale
	elif [[ "$1" == "${options[3]}" ]]; then
		firefox --new-window 'https://virtuale.unibo.it/' &
	# whatsapp web
	elif [[ "$1" == "${options[4]}" ]]; then
		firefox --new-window 'https://web.whatsapp.com/' &
	# google drive
	elif [[ "$1" == "${options[5]}" ]]; then
		firefox --new-window 'https://drive.google.com' &
	# prolog engine 
	elif [[ "$1" == "${options[6]}" ]]; then
		firefox --new-window 'https://swish.swi-prolog.org/' &
	elif [[ "$1" == "${options[7]}" ]]; then
		firefox --new-window 'https://play.pokemonshowdown.com/' &
	fi
}

# Actions
chosen="$(run_rofi)"
run_cmd "$chosen"

