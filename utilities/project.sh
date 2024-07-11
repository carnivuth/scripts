#!/bin/bash
help(){
        echo "Usage $0 [project folder]"
}

open_project(){

  # avoid nested sessions
  [ -n "$TMUX" ] && echo already in a tmux session  && exit 1

  # enter project if path is given
  if [[ -d "$1" ]];then
         cd "$1"
  fi

  # get project name by the current directory
  PROJECT_NAME="$(basename $(pwd))"

  # if session already exists attach to the session
  SESSION_STATUS="$(tmux ls | grep "$PROJECT_NAME")"
  if [[ "$SESSION_STATUS" != '' ]]; then
    tmux attach-session -t "$PROJECT_NAME"

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
