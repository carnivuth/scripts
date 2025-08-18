#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"

list_app(){
  find $HOME/.local/share/applications/ /usr/share/applications/ -name '*.desktop'   -exec basename {} .desktop \; |  sed 's/^/app:/g'
}

run_app(){
  app_file="$(find "$HOME/.local/share/applications/" "/usr/share/applications/" -name "$1.desktop")"
  gio launch "$app_file"
}
