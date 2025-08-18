#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"

list_app(){
  find $HOME/.local/share/applications/ /usr/share/applications/ -name '*.desktop'   -exec basename {} .desktop \; |  sed 's/^/app:/g'
}

run_app(){
        echo gtk-launch "$1" >> /tmp/debug
        gtk-launch "$1" >> /tmp/debug
}
