#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/rofi_standard.sh"

rofi_theme_setup $ROFI_CONFIG_FOLDER/quicksearch "$1" "search with firefox"

# main
chosen="$(rofi_cmd "${prompt}" )"
if [ "$chosen" != "" ]; then
	case "$chosen" in
	https*)
		xdg-open "$chosen"
		;;
	http*)
		xdg-open "$chosen"
		;;
	*) 
			firefox --new-window --search "$chosen"
		 ;;
	esac
fi
