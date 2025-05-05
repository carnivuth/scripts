#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

menu_cmd() {
  wofi -d --show dmenu -p "$1"
}
