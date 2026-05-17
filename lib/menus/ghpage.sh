#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/launch_webapp.sh"

list_ghpage(){
  gh repo list --json homepageUrl | jq '[.[].homepageUrl | select(length > 0)][]' -r | sed 's/^/ghpage:/g'
}

run_ghpage(){
  launch_webapp "$1"
}
