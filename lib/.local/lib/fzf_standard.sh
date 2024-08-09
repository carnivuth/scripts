#!/bin/bash
source "$HOME/.config/settings.sh"

menu_theme_setup(){
  echo "" > "/dev/null"
}

menu_cmd() {
  fzf --prompt "$1"
}
