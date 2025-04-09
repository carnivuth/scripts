#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/launch_webapp.sh"
source "$SCRIPTS_LIB_FOLDER/print_bins.sh"
source "$SCRIPTS_LIB_FOLDER/print_desktop_files.sh"

MENU_NAME="launcher"
PROMPT="programs"

help_message(){
  echo "launcher for binaries and web applications"
}

list_elements_to_user(){
  apps="$(jq -r '.[].site' $SCRIPTS_VAR_FOLDER/sites.json.d/*.json "$SCRIPTS_VAR_FOLDER/sites.json") $( print_bins )"
  echo $apps | sed  's/ /\n/g'
}

exec_command_with_chosen_element(){
  # open site
  if [[ ! -x "$( which "$1" 2>/dev/null)" ]];then
    site="$( jq -r ".[] | select(.site == \"$1\")| .link " $SCRIPTS_VAR_FOLDER/sites.json.d/*.json "$SCRIPTS_VAR_FOLDER/sites.json" )"
    if [[ "$site" != '' ]];then
      launch_webapp "$site"
    fi
  else
    # check for desktop file
    if grep "^Exec=.*$1.*" /usr/share/applications/* -l; then
      # check if Terminal=true set
      if grep '^Terminal=true' "$(grep "^Exec=$1" /usr/share/applications/* -l )"; then
        $FLOATING_TERMINAL_CMD "$1"
      else
        # exec program if desktop file present but not Terminal=true set
        exec "$1"
      fi
    else
        $FLOATING_TERMINAL_CMD "$1"
    fi
  fi
}

source "$SCRIPTS_LIB_FOLDER/menu.sh"
