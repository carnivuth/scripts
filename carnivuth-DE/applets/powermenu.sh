#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER"/"$MENU_BACKEND"_standard.sh

menu_theme_setup "powermenu"

# set menu entries based on format setting
if [[ $POWERMENU_FORMAT == 'long' ]]; then 
  shutdown='  shutdown'
  reboot='  reboot' 
  lock='  lock'
  suspend='  suspend'
  logout='  logout'
fi 

if [[ $POWERMENU_FORMAT == 'short' ]]; then 
  shutdown=''
  reboot='' 
  lock=''
  suspend=''
  logout=''
fi

# COMMAND FUNCTIONS
SHUTDOWN='systemctl poweroff'
REBOOT='systemctl reboot'
SUSPEND='systemctl suspend'

# logout function based on DESKTOP_SESSION env var
logout(){

  case "$DESKTOP_SESSION" in
    openbox)
	  	openbox --exit
    	;;
    bspwm)
	  	bspc quit
    	;;
    i3)
	  	i3-msg exit
    	;;
    hyprland)
      HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
      hyprctl --batch "$HYPRCMDS" >> /tmp/hypr/hyprexitwithgrace.log 2>&1
	  	hyprctl dispatch exit
    	;;
    awesome)
	  	killall awesome
    	;;
    plasma)
	  	qdbus org.kde.ksmserver /KSMServer logout 0 0 0
    	;;
    esac

}

# lock function based on which lockscreen is installed 
lock(){

	if [[ -x '/usr/bin/betterlockscreen' ]]; then
		betterlockscreen -l
	elif [[ -x '/usr/bin/swaylock' ]]; then
		swaylock 
	elif [[ -x '/usr/bin/dm-tool' ]]; then
		dm-tool lock
	elif [[ -x '/usr/bin/i3lock' ]]; then
		i3lock
	fi

}


# print menu function
print_powermenu() {
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | menu_cmd $prompt
}

# Actions
chosen="$(print_powermenu)"
case ${chosen} in
$shutdown)
	$SHUTDOWN
	;;
$reboot)
	$REBOOT
	;;
$suspend)
	$SUSPEND
	;;
$lock)
	lock
	;;
$logout)
	logout
	;;
esac
