#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/menu_standard.sh"

menu_theme_setup quicksearch 

# main
chosen="$(menu_cmd "${prompt}" )"
if [ "$chosen" != "" ]; then
	case "$chosen" in
	https*)
		firefox --new-window "$chosen"
		;;
	http*)
		firefox --new-window "$chosen"
		;;
	*) 
			firefox --new-window --search "$chosen"
		 ;;
	esac
fi
