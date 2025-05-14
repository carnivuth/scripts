#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
get_file(){
  if ping -c 1 "api.github.com" > /dev/null 2>&1; then
    curl "https://api.github.com/users/$GITHUB_REPOVIEWER_ACCOUNT/repos?per_page=100" > "$SCRIPTS_LOCAL_FOLDER/repos.json"
  fi
}
function get_github_repos(){

  # check if cache is valid
  if [[ ! -f "$SCRIPTS_LOCAL_FOLDER/repos.json" ]] || [[ "$(wc -l "$SCRIPTS_LOCAL_FOLDER/repos.json")" == "0" ]]; then get_file; fi
  birth_date="$(stat -c '%W' "$SCRIPTS_LOCAL_FOLDER/repos.json" )"
  today="$(date +%s)"

  # refresh cache if is too old
  if [[ "$(($today - $birth_date))" -gt 86400  ]]; then
    rm "$SCRIPTS_LOCAL_FOLDER/repos.json"
    get_file
  fi
}
