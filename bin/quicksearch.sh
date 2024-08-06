#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER"/"$MENU_BACKEND"_standard.sh

menu_theme_setup quicksearch

# main
chosen="$(menu_cmd "search with firefox" )"
if [ "$chosen" != "" ]; then
	case "$chosen" in
	https*)
		firefox --new-tab "$chosen"
		;;
	http*)
		firefox --new-tab "$chosen"
		;;
	*)
			firefox --new-tab "$BASE_QUICKSEARCH_URL$chosen"
		 ;;
	esac

  # draw attention to the firefox window if running on hyprland
  if [[ "$XDG_CURRENT_DESKTOP" == 'Hyprland' ]]; then
    hyprctl dispatch 'focuswindow firefox'
  fi

  # draw attention to the firefox window if running on i3
  if [[ "$XDG_CURRENT_DESKTOP" == 'i3' ]]; then
    i3-msg '[class="firefox"] focus'
  fi

fi
