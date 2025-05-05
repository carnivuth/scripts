#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

menu_cmd() {
  fzf --prompt "$1"
}
