#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

RESULT_FILE="$(mktemp)"
echo "0" > "$RESULT_FILE"

function sync(){
  for repo in ${GIT_REPOS}; do
    if [[ -d "$repo/.git" ]] && grep -q "remote" "$repo/.git/config" ; then
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

case "$1" in
  sync)
    sync
    ;;
  *)
    echo "usage $0 sync"
    ;; esac
