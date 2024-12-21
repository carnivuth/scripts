#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

MENU_NAME="quicksearch"
PROMPT="search with firefox"

help_message(){
  echo "script for make searches using firefox"
}
list_elements_to_user(){
  cat "/dev/null"
}

exec_command_with_chosen_element(){
	case "$1" in
	https*)
		firefox --new-tab "$1"
		;;
	http*)
		firefox --new-tab "$1"
		;;
	*)
			firefox --new-tab "$BASE_QUICKSEARCH_URL$1"
		 ;;
	esac
  # draw attention to the firefox window if running on hyprland
  if [[ "$XDG_CURRENT_DESKTOP" == 'Hyprland' ]]; then
    hyprctl dispatch 'focuswindow class:firefox'
  fi

  # draw attention to the firefox window if running on i3
  if [[ "$XDG_CURRENT_DESKTOP" == 'i3' ]]; then
    i3-msg '[class="firefox"] focus'
  fi
}
source "$SCRIPTS_LIB_FOLDER/menu.sh"
