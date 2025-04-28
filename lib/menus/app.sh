#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"

list_app(){
  grep -o -e '^Exec=.*' $HOME/.local/share/applications/* /usr/share/applications/*.desktop | awk -F'[ =]' '{print $2}' | awk -F'/' '{print $NF}' | sort -u | sed 's/^/app:/g'
}

run_app(){
        exec "$1"
}
