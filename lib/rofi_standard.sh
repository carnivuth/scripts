#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

menu_theme_setup() {
  theme="$ROFI_CONFIG_FOLDER/$1/$1.rasi"
}

menu_cmd() {
  rofi  -dmenu -p "$1" -config ${theme}
}
