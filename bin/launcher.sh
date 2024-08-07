#!/usr/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/launch_webapp.sh"
source "$SCRIPTS_LIB_FOLDER/print_bins.sh"

MENU_NAME="launcher"
PROMPT="programs"


help_message(){
  echo "launcher for binaries and desktop files "
}
list_elements_to_user(){
  apps="$( print_bins )"
  apps="$(jq -r '.app' "$SCRIPTS_LOCAL_FOLDER/sites.json") $apps "
  echo $apps | sed  's/ /\n/g'
}

exec_command_with_chosen_element(){
  if [[ ! -x "$( which "$1" 2>/dev/null)" ]];then
    site="$( jq -r "select(.app == \"$1\")| .link " "$SCRIPTS_LOCAL_FOLDER/sites.json" )"
    if [[ "$site" != '' ]];then
      launch_webapp "$site"
    fi
  else
    exec "$1"
  fi
}

# create json structure from desktop files
desktop_files_to_json(){
  ls "$SCRIPTS_DESKTOPFILES_FOLDER" | while read -r filename; do
  app="$(basename "$SCRIPTS_DESKTOPFILES_FOLDER/$filename"  | awk -F'.' '{print $1}')";
  link="$(grep webapp "$SCRIPTS_DESKTOPFILES_FOLDER/$filename" | awk -F \' '{print $2}' )"
  if [[ "$link" != '' ]] && [[ "$app" != '' ]]; then
    echo "{ \"app\": \"$app\",\"link\": \"$link\"}"
  fi
done
}

source "$SCRIPTS_LIB_FOLDER/menu.sh"
