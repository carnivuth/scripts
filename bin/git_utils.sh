#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/notify.sh"

declare -A FLAGS
FLAGS_STRING='t:m:r:'
FLAGS[t]='TAG=${OPTARG}'
FLAGS[m]='MESSAGE=${OPTARG}'
FLAGS[r]='GIT_REPOS=${OPTARG}'

declare -A FLAGS_DESCRIPTIONS
FLAGS_DESCRIPTIONS[t]='git tag to create'
FLAGS_DESCRIPTIONS[m]='git message'
FLAGS_DESCRIPTIONS[r]='git repos to target'

declare -A COMMANDS
COMMANDS[sync]="sync repos specified in the config file"
COMMANDS[prmain]="make a pull request to main branch and accept it"
COMMANDS[mgmain]="merge branch to main and push"
COMMANDS[tag]="create a tag with a given name and push to remote"
COMMANDS[check]="check status of git repos"

APP_NAME="github sync"
APP_ICON="/usr/share/icons/Papirus/16x16/apps/github.svg"

function repo_is_ignored(){
  repo="$1"
  for remote in ${GIT_IGNORED_REMOTES};do
    if [[ $(grep url "$repo/.git/config" | awk -F'=' '{ print $2}') =~ "$remote" ]]; then return 0; fi
  done
  return 1;
}

function check(){

  for repo in ${GIT_REPOS}; do

    # check if folder is a git repo and the remote is not in the ignore config
    if [[ -f "$repo/.git/config" ]]  && ! repo_is_ignored "$repo"; then
      (
      echo "checking repo $repo"
      cd "$repo" && git status

      echo "--------------------"
    )
    fi
  done

}

function repo_sync(){
    repo="$1"
}


function sync(){
  RESULT_FILE="$(mktemp)"
  echo "0" > "$RESULT_FILE"

  export -f repo_is_ignored
  echo ${GIT_REPOS}  | tr ' ' '\n' | parallel 'if [[ -f "{}/.git/config" ]] && grep -q "remote" "{}/.git/config" && ! repo_is_ignored "{}"; then echo "updating repo {}"; cd "{}" && git pull || echo "{.}" > "$RESULT_FILE"; echo "--------------------"; fi'

  if [[ "$(cat "$RESULT_FILE")" == "0" ]]; then
    notify "normal" "done sync of git repos"
  else
    notify "critical" " $(cat "$RESULT_FILE") could not be synched"
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
  if [[ -z $TAG ]]; then echo 'tag is required use option -t'; exit 1;fi
  if [[ -z $MESSAGE ]]; then echo 'message is required use option -m'; exit 1;fi
  branch="$(git branch | grep   '*' | awk -F' ' '{print $2}' )"
  if [[ "$branch" != 'main' ]]; then echo 'you are not in the main branch, exiting'; exit 1; fi
  git tag -a "$TAG" -m "$MESSAGE"
  git push origin tag "$TAG"
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
