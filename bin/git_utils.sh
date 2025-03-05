#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

declare -A FLAGS
FLAGS_STRING='t:m:'
FLAGS[t]='TAG=${OPTARG}'
FLAGS[m]='MESSAGE=${OPTARG}'

declare -A COMMANDS
COMMANDS[sync]="sync repos specified in the config file"
COMMANDS[prmain]="make a pull request to main branch and accept it"
COMMANDS[mgmain]="merge branch to main and push"
COMMANDS[tag]="create a tag with a given name and push to remote"

function repo_is_ignored(){
  repo="$1"
  for remote in ${GIT_IGNORED_REMOTES};do
    if [[ $(grep url "$repo/.git/config" | awk -F'=' '{ print $2}') =~ "$remote" ]]; then return 0; fi
  done
  return 1;
}

function sync(){
  RESULT_FILE="$(mktemp)"
  echo "0" > "$RESULT_FILE"
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

function prmain(){

  if [[ ! -d .git ]]; then echo 'not in a git repository, exiting'; exit 1; fi
  branch="$(git branch | grep   '*' | awk -F' ' '{print $2}')"
  if [[ "$branch" == 'main' ]]; then echo 'you are in the main branch, exiting'; exit 0; fi

  gh pr create --base 'main' --fill
  gh pr merge -m --auto
}

function mgmain(){
  if [[ ! -d .git ]]; then echo 'not in a git repository, exiting'; exit 1; fi
  branch="$(git branch | grep   '*' | awk -F' ' '{print $2}' )"
  if [[ "$branch" == 'main' ]]; then echo 'you are in the main branch, exiting'; exit 1; fi

  # switch to main branch, merge current, push branch and switch back to previous branch
  git switch main && git merge "$branch" && git push && git switch "$branch"
}

function tag(){
  if [[ ! -d .git ]]; then echo 'not in a git repository, exiting'; exit 1; fi
  if test -z $TAG; then echo 'tag is required use option -t'; exit 1;fi
  if test -z $MESSAGE; then echo 'message is required use option -m'; exit 1;fi
  branch="$(git branch | grep   '*' | awk -F' ' '{print $2}' )"
  if [[ "$branch" != 'main' ]]; then echo 'you are not in the main branch, exiting'; exit 1; fi
  git tag -a "$TAG" -m "$MESSAGE"
  git push origin tag "$TAG"
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
