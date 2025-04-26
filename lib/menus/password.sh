#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"

list_password(){
  find ~/.password-store/ -name '*.gpg'| sed -e 's|.*.password-store/||g' -e 's|.gpg||g' | sed 's/^/password:/g'
}

run_password(){
  pass -c "$1"
}
