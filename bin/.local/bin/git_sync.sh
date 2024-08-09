#!/bin/bash
source "$HOME/.config/settings.sh"
RESULT_FILE="$(mktemp)"
echo "0" > "$RESULT_FILE"

function sync(){
  for repo in ${GIT_REPOS}; do
          echo "updating repo $repo"
          cd "$repo" && git pull || echo "1" > "$RESULT_FILE"

          echo "--------------------"
  done
  if [[ "$(cat "$RESULT_FILE")" == "0" ]]; then
    notify-send -a "git sync" -u "normal" "done sync of git repos"
  else
    notify-send -a "git sync" -u "critical" "some repos could not be synched"
  fi
  rm "$RESULT_FILE"

}

case "$1" in
  sync)
    sync
    ;;
  *)
    echo "usage $0 sync"
    ;; esac
