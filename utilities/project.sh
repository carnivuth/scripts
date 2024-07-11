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

  PROJECT_NAME="$(basename $(pwd))"
  tmux new  -s "$PROJECT_NAME" vim \; \
  split-window  -h -l 60 \; \
  selectp -t 0
}

case $1 in
    --help)
       help
       ;;
    *)
       open_project $1
       ;;
esac
