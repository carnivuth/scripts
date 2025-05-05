#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

menu_cmd() {
  rofi  -dmenu -p "$1"
}
