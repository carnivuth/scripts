#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/launch_webapp.sh"

list_s(){
  true
}

run_s(){
	case "$1" in
	https://*)
		launch_webapp "$1"
    break
		;;
	http://*)
		launch_webapp "$1"
    break
		;;
	*)
		launch_webapp "$BASE_QUICKSEARCH_URL$1"
    break
		;;
	esac
}
