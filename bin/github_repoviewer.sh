#!/usr/bin/bash

source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/launch_webapp.sh"

# SCRIPT SPECIFIC VARS AND FUNCTIONS
BASE_URL="https://github.com/$GITHUB_REPOVIEWER_ACCOUNT"

get_file(){
  curl "https://api.github.com/users/$GITHUB_REPOVIEWER_ACCOUNT/repos?per_page=100" > "$SCRIPTS_LOCAL_FOLDER/repos.json"
}

# GENERAL MENU VARS AND FUNCTIONS
MENU_NAME="github_repoviewer"
PROMPT="github repos"

help_message(){
  echo "script for quick access to web interface of personal github repos"
  echo "usage $0"
}

list_elements_to_user(){
  # check if cache is valid
  if [[ ! -f "$SCRIPTS_LOCAL_FOLDER/repos.json" ]]; then get_file; fi
  birth_date="$(stat -c '%W' "$SCRIPTS_LOCAL_FOLDER/repos.json" )"
  today="$(date +%s)"
  if [[ "(($today - $birth_date))" -gt 86400  ]]; then
    rm "$SCRIPTS_LOCAL_FOLDER/repos.json"
    get_file
  fi

  # printing list
  jq -r '.[].name' "$SCRIPTS_LOCAL_FOLDER/repos.json"
}

exec_command_with_chosen_element(){
  launch_webapp "$BASE_URL/$chosen"

    # draw attention to the firefox window if running on hyprland
    if [[ "$XDG_CURRENT_DESKTOP" == 'Hyprland' ]]; then
      hyprctl dispatch 'focuswindow firefox'
    fi
  }

source "$SCRIPTS_LIB_FOLDER/menu.sh"
