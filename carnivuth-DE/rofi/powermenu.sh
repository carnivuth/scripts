#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/menu_standard.sh"
host="$(cat /etc/hostname)"
menu_theme_setup "powermenu"

# Options
shutdown='  shutdown'
reboot='  reboot' 
lock='  lock'
suspend='  suspend'
logout='  logout'
#shutdown=''
#reboot='' 
#lock=''
#suspend=''
#logout=''


print_powermenu() {
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | menu_cmd $prompt
}

# Execute Command
run_cmd() {

	if [[ $1 == '--shutdown' ]]; then
		systemctl poweroff
	elif [[ $1 == '--reboot' ]]; then
		systemctl reboot
	elif [[ $1 == '--suspend' ]]; then
		systemctl suspend
	elif [[ $1 == '--logout' ]]; then
		if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
			openbox --exit
		elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
			bspc quit
		elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
			i3-msg exit
		elif [[ "$DESKTOP_SESSION" == 'awesome' ]]; then
			killall awesome
		elif [[ "$DESKTOP_SESSION" == 'plasma' ]]; then
			qdbus org.kde.ksmserver /KSMServer logout 0 0 0
		fi
	fi

}

# Actions
chosen="$(print_powermenu)"
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
	elif [[ -x '/usr/bin/swaylock' ]]; then
		swaylock -i /usr/share/hyprland/wall_anime_4K.png
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
