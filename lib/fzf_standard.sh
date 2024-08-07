#!/bin/bash
source "$HOME/scripts/settings.sh"

menu_theme_setup(){
  echo "" > "/dev/null"
}

menu_cmd() {
  fzf --prompt "$1"
}
