#!/usr/bin/bash

# Current Theme
dir="$HOME/.config/rofi/powermenu"
theme='snorlax-line'

# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"
host="$(cat /etc/hostname)"

# Options
shutdown=''
reboot=''
lock=''
suspend=''
logout=''
yes=''
no=''

# Rofi CMD
rofi_cmd() {
	if [ -f "${dir}/${theme}.rasi"  ]; then
		rofi -dmenu \
			-p "$host" \
			-mesg "Uptime: $uptime" \
			-theme ${dir}/${theme}.rasi
	else
		rofi -dmenu \
			-p "$host" \
			-mesg "Uptime: $uptime" \
	
	fi
}




# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {

		if [[ $1 == '--shutdown' ]]; then
			systemctl poweroff
		elif [[ $1 == '--reboot' ]]; then
			systemctl reboot
		elif [[ $1 == '--suspend' ]]; then
			mpc -q pause
			amixer set Master mute
			dm-tool lock
			systemctl suspend
		elif [[ $1 == '--logout' ]]; then
			if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
				openbox --exit
			elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
				bspc quit
			elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
				i3-msg exit
			elif [[ "$DESKTOP_SESSION" == 'plasma' ]]; then
				qdbus org.kde.ksmserver /KSMServer logout 0 0 0
			fi
		fi

}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		run_cmd --shutdown
        ;;
    $reboot)
		run_cmd --reboot
        ;;
    $lock)
		if [[ -x '/usr/bin/betterlockscreen' ]]; then
			betterlockscreen -l
		elif [[ -x '/usr/bin/dm-tool' ]]; then
			dm-tool lock
		elif [[ -x '/usr/bin/i3lock' ]]; then
			i3lock
	
		fi 
        ;;
    $suspend)
		run_cmd --suspend
        ;;
    $logout)
		run_cmd --logout
        ;;
esac
