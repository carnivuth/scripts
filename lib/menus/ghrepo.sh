#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/get_github_repos.sh"
source "$SCRIPTS_LIB_FOLDER/launch_webapp.sh"

# SCRIPT SPECIFIC VARS AND FUNCTIONS
BASE_URL="https://github.com/$GITHUB_REPOVIEWER_ACCOUNT"

list_ghrepo(){

  get_github_repos

  # printing list
  jq -r '.[].name' "$SCRIPTS_LOCAL_FOLDER/repos.json" | sed 's/^/ghrepo:/'
}

run_ghrepo(){
  launch_webapp "$BASE_URL/$1"

    # draw attention to the firefox window if running on hyprland
    if [[ "$XDG_CURRENT_DESKTOP" == 'Hyprland' ]]; then
      hyprctl dispatch 'focuswindow firefox'
    fi
  }
