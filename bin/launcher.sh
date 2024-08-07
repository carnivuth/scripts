#!/usr/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/launch_webapp.sh"
source "$SCRIPTS_LIB_FOLDER/print_bins.sh"

MENU_NAME="launcher"
PROMPT="programs"

help_message(){
  echo "launcher for binaries and web applications"
}

list_elements_to_user(){
  apps="$( print_bins )"
  apps="$(jq -r '.[].site' "$SCRIPTS_VAR_FOLDER/sites.json") $apps "
  echo $apps | sed  's/ /\n/g'
}

exec_command_with_chosen_element(){
  if [[ ! -x "$( which "$1" 2>/dev/null)" ]];then
    site="$( jq -r ".[] | select(.site == \"$1\")| .link " "$SCRIPTS_VAR_FOLDER/sites.json" )"
    if [[ "$site" != '' ]];then
      launch_webapp "$site"
    fi
  else
    exec "$1"
  fi
}

source "$SCRIPTS_LIB_FOLDER/menu.sh"
