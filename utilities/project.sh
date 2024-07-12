#!/bin/bash
DEPS="vim tmux"
help(){
        echo "Usage $0 [project folder]"
}
checks(){

  # check if tmux is installed
  [ ! -x "$(which tmux)" ] && echo tmux binary not found  && return 1

  # avoid nested sessions
  [ -n "$TMUX" ] && echo already in a tmux session  && return 1
  return 0
}

open_project(){

  # do checks
  checks "$1" || exit 1

  # enter project if path is given
  if [[ "$1" != '' ]]; then
    if [[ -d "$1" ]];then
           cd "$1"
   else
           echo "$1 folder does not exists"
           exit 1
    fi
  fi

  # get project name by the current directory
  PROJECT_NAME="$(basename $(pwd))"

  # if session already exists attach to the session
  SESSION_STATUS="$(tmux ls | grep "$PROJECT_NAME")"
  if [[ "$SESSION_STATUS" != '' ]]; then
    tmux attach-session -t "$PROJECT_NAME"\; \
    selectp -t 0

  else
    # start a new session with the standard setup
    tmux new  -s "$PROJECT_NAME" vim \; \
    split-window  -h -l 60 \; \
    selectp -t 0
  fi
}

case $1 in
    --help)
       help
       ;;
    *)
       open_project $1
       ;;
esac
