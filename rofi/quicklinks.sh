#!/usr/bin/bash

# Current Theme
dir="$HOME/.config/rofi/quicklinks"
theme='snorlax-line'

if [ "$#" -eq 1 ]; then 
    theme="$1"
fi

# Theme Elements
prompt='Quick Links'
mesg="Using '$BROWSER' as web browser"



# Options
	option_1=""
	option_2=""
	option_3=""
	option_4=""
	option_5=""
	option_6=""
	option_7=""
	option_9=""


# Rofi CMD
rofi_cmd() {
	if [ -f "${dir}/${theme}.rasi"  ]; then

		rofi -dmenu \
			-p "$prompt" \
			-mesg "$mesg" \
			-markup-rows \
			-theme ${dir}/${theme}.rasi
	else
		rofi -dmenu \
			-p "$prompt" \
			-mesg "$mesg" \
			-markup-rows \

	fi
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_3\n$option_4\n$option_5\n$option_6\n$option_7\n$option_9" | rofi_cmd
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		firefox --new-window 'https://www.google.com/' &
	elif [[ "$1" == '--opt2' ]]; then
		thunderbird &
	elif [[ "$1" == '--opt3' ]]; then
		firefox --new-window 'https://www.youtube.com/' &
	elif [[ "$1" == '--opt4' ]]; then
		firefox --new-window 'https://www.github.com/' &
	elif [[ "$1" == '--opt5' ]]; then
		firefox --new-window 'https://www.reddit.com/' &
	elif [[ "$1" == '--opt6' ]]; then
		firefox --new-window 'https://virtuale.unibo.it/' &
	elif [[ "$1" == '--opt7' ]]; then
		firefox --new-window 'https://web.whatsapp.com/' &
	elif [[ "$1" == '--opt9' ]]; then
		firefox --new-window 'https://drive.google.com' &

	
	fi
}

# Actions
chosen="$(run_rofi)"
printf $chosen
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
    $option_3)
		run_cmd --opt3
        ;;
    $option_4)
		run_cmd --opt4
        ;;
    $option_5)
		run_cmd --opt5
        ;;
    $option_6)
		run_cmd --opt6
        ;;
	$option_7)
		run_cmd --opt7
        ;;
	$option_9)
		run_cmd --opt9
        ;;

	*)
		;;
esac
