#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

list_s(){
  true
}

run_s(){
	case "$1" in
	https://*)
		firefox --new-tab "$1"
		;;
	http://*)
		firefox --new-tab "$1"
		;;
	*)
			firefox --new-tab "$BASE_QUICKSEARCH_URL$1"
		 ;;
	esac

  # draw attention to the firefox window if running on hyprland
  if [[ "$XDG_CURRENT_DESKTOP" == 'Hyprland' ]]; then
    hyprctl dispatch 'focuswindow class:[Ff]irefox'
  fi

  # draw attention to the firefox window if running on i3
  if [[ "$XDG_CURRENT_DESKTOP" == 'i3' ]]; then
    i3-msg '[class="firefox"] focus'
  fi
}
