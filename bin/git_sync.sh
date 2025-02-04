#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

declare -A FLAGS
FLAGS_STRING=''

declare -A COMMANDS
COMMANDS[sync]="sync repos specified in the config file"
RESULT_FILE="$(mktemp)"
echo "0" > "$RESULT_FILE"

function repo_is_ignored(){
  repo="$1"
  for remote in ${GIT_IGNORED_REMOTES};do
    if [[ $(grep url "$repo/.git/config" | awk -F'=' '{ print $2}') =~ "$remote" ]]; then return 0; fi
  done
  return 1;
}

function sync(){
  for repo in ${GIT_REPOS}; do
    # check if folder is a git repo with a remote configured and the remote is not in the ignore config
    if [[ -f "$repo/.git/config" ]] && grep -q "remote" "$repo/.git/config" && ! repo_is_ignored "$repo"; then
      (
      echo "updating repo $repo"
      cd "$repo" && git pull || echo "1" > "$RESULT_FILE"

      echo "--------------------"
    )
    fi
  done
  if [[ "$(cat "$RESULT_FILE")" == "0" ]]; then
    notify-send -i "$GIT_NOTIFICATION_ICON" -a "$GIT_NOTIFICATION_NAME" -u "normal" "done sync of git repos"
  else
    notify-send -i "$GIT_NOTIFICATION_ICON" -a "$GIT_NOTIFICATION_NAME" -u "critical" "some repos could not be synched"
  fi
  rm "$RESULT_FILE"

}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
