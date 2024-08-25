#!/usr/bin/bash

launch_webapp(){
  source "$HOME/.config/scripts/settings.sh"
  
  firefox --new-tab "$1"
  
  # draw attention to the firefox window based on window manager
  if [[ "$XDG_CURRENT_DESKTOP" == 'Hyprland' ]]; then
    hyprctl dispatch 'focuswindow firefox'
  fi
  
  if [[ "$XDG_CURRENT_DESKTOP" == 'i3' ]]; then
    i3-msg '[class="firefox"] focus'
  fi
}
