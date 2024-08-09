#!/bin/bash
source "$HOME/.config/settings.sh"

menu_theme_setup(){
  STYLE="$WOFI_CONFIG_FOLDER/$1/$1.css"
  CONFIG="$WOFI_CONFIG_FOLDER/$1/$1"
}

# $1 wofi prompt
menu_cmd() {
  wofi -d --show dmenu \
    -p "$1" \
    -s "$STYLE"\
    -c "$CONFIG"
  }
