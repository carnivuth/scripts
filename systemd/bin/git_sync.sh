#!/bin/bash
source "$HOME/scripts/settings.sh"

function sync(){
  for repo in ${GIT_REPOS}; do
          echo "entering repo $repo"
          cd "$repo"
          echo "updating repo $repo"
          git pull
          echo "--------------------"
  done
}

case "$1" in
  sync)
    sync
    ;;
  *)
    echo "usage $0 sync"
    ;;
esac
