#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

list_file(){
  find $HOME -type f -not -path '*/.*' -not -path '*/site-packages/*' -not -path '*/env/*' -not -path '*/go/pkg*' -mount | sed 's/^/file:/g'
}

run_file(){
  chosen="$1"
  gio open "$chosen"
}
