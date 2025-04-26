#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
list_ksprofile(){
  grep profile ~/.config/kanshi/config | awk -F' ' '{print $2}' | sed 's/^/ksprofile:/'
}

run_ksprofile(){
  kanshictl switch $1
}
