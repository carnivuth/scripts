#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

declare -A FLAGS
FLAGS_STRING=''

declare -A COMMANDS
COMMANDS[docker]="clean docker env"
COMMANDS[vagrant]="clean vagrant env"
COMMANDS[ollama]="clean ollama env"

function docker(){
  docker ps | awk -F' ' '{print $1}' | tail -n +2 | xargs docker container kill
  docker system prune -a -f
  docker image prune -a -f
  docker volume prune -a -f
  docker network prune -f
}

function vagrant(){
  MACHINES="$(vagrant global-status --machine-readable | grep machine-id | awk -F , '{print $4}')"

  echo "$MACHINES" | while read machine ; do
    vagrant destroy -f $machine
  done

}

function ollama(){

  ollama list | tail -n +2 | awk -F' ' '{print $1}' | while read model; do ollama rm "$model"; done
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
