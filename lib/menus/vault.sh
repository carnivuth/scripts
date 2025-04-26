#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

list_vault(){
  jq -r '.vaults[].path' "$HOME/.config/obsidian/obsidian.json" | sed 's/^/vault:/g'
}

run_vault(){
  if [[ -d "$1" ]];then
    obsidian "obsidian://open?path=$1" &
  fi
}
