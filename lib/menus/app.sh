#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"

list_app(){
  find $HOME/.local/share/applications/ /usr/share/applications/ -name '*.desktop'   -exec basename {} .desktop \; | sort -u |  sed 's/^/app:/g'
}

run_app(){
  app_file="$(find "$HOME/.local/share/applications/" "/usr/share/applications/" -name "$1.desktop" | head -n 1)"
  gio launch "$app_file"
}
