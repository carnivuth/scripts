#!/usr/bin/bash

source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/get_github_repos.sh"
source "$SCRIPTS_LIB_FOLDER/launch_webapp.sh"

# SCRIPT SPECIFIC VARS AND FUNCTIONS
BASE_URL="https://github.com/$GITHUB_REPOVIEWER_ACCOUNT"

# GENERAL MENU VARS AND FUNCTIONS
MENU_NAME="github_repoviewer"
PROMPT="github repos"

help_message(){
  echo "script for quick access to web interface of personal github repos"
  echo "usage $0"
}

list_elements_to_user(){

  get_github_repos
  # printing list
  jq -r '.[].name' "$SCRIPTS_LOCAL_FOLDER/repos.json"
}

exec_command_with_chosen_element(){
  launch_webapp "$BASE_URL/$1"

    # draw attention to the firefox window if running on hyprland
    if [[ "$XDG_CURRENT_DESKTOP" == 'Hyprland' ]]; then
      hyprctl dispatch 'focuswindow firefox'
    fi
  }

source "$SCRIPTS_LIB_FOLDER/menu.sh"
