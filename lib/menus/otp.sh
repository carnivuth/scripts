#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"

list_otp(){
  find ~/.password-store/ -name '*.gpg'| sed -e 's|.*.password-store/||g' -e 's|.gpg||g' | sed 's/^/otp:/g'
}

run_otp(){
  pass otp -c "$1"
}
