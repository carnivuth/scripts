#!/bin/bash

# LIB FOR CLI APPLICATION COMMON UTILS, TO SOURCE AT THE END OF A CLI APPLICATION
# define the following flags
#
#declare -A FLAGS
#FLAGS[ciw]="ciw"
#FLAGS_STRING=''
#
#declare -A COMMANDS
#COMMANDS[ciw]="ciw"

source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/check_if_function_exist.sh"

if  ! declare -p COMMANDS >/dev/null 2>&1; then echo "COMMANDS array not declared"; exit 1; fi
if  ! declare -p FLAGS >/dev/null 2>&1; then echo "FLAGS array not declared"; exit 1; fi
if  ! declare -p FLAGS_DESCRIPTIONS >/dev/null 2>&1; then echo "FLAGS_DESCRIPTIONS array not declared"; exit 1; fi

COMMANDS[help]="show this help command"

function help(){
  echo "usage: $(basename "$0") COMMAND [$FLAGS_STRING]"
  echo "list of commands:"
  for command in "${!COMMANDS[@]}"; do
    echo "       $command -> ${COMMANDS[$command]}"
  done
  echo "list of flags:"
  for flag in "${!FLAGS_DESCRIPTIONS[@]}"; do
    echo "       -$flag -> ${FLAGS_DESCRIPTIONS[$flag]}"
  done
}

for command in ${!COMMANDS[@]}; do
  check_if_function_exist "$command"
done

# MAIN, PARSE PARAMETERS
COMMAND="$1"
shift
if [[ $COMMAND  == '' ]] || [[ $COMMAND  == -* ]]; then echo "first parameter must be a command"; help; exit 1; fi

if [[ ! -z $FLAGS_STRING ]];then
  while getopts $FLAGS_STRING flag; do
    [ "${FLAGS[$flag]}" ] && eval ${FLAGS[$flag]}
  done
fi

if [ "${COMMANDS[$COMMAND]}" ]; then
  "$COMMAND"
else
  echo "$COMMAND not exists"
  help
  exit 1
fi
