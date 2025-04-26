#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/print_desktop_files.sh"

list_app(){
  print_desktop_files | sed 's/^/app:/g'
}

run_app(){
        exec "$1"
}
