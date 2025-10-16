#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/launch_webapp.sh"

list_ghrepo(){
  gh repo list --json url | jq -r '.[].url' | sed 's/^/ghrepo:/'
}

run_ghrepo(){
  launch_webapp "$1"
  # draw attention to the firefox window if running on hyprland
  if [[ "$XDG_CURRENT_DESKTOP" == 'Hyprland' ]]; then
    hyprctl dispatch 'focuswindow firefox'
  fi
  }
