#!/usr/bin/bash
MENU_NAME="launchprojects"
PROMPT="projects"
source "$HOME/.config/scripts/settings.sh"

help_message(){
  echo " script for opening project folders in specified editor"
  echo " usage $0 [-e editor]"
  echo " -e editor: editor where to open projects, it must support the sintax 'editor folder/to/open' if not specified default in settings is used"
}
list_elements_to_user(){
  echo -e "$(for dir in $LAUNCHPROJECTS_FOLDERS; do ls -d "$dir"/*/; done)"
}

exec_command_with_chosen_element(){
  if [ -d "$chosen" ]; then
    "$EDITOR_COMMAND" "$@" "$chosen"
  fi
}

# set editor command
EDITOR_COMMAND="$LAUNCHPROJECTS_DEFAULT_EDITOR"
while getopts e:b:h flag; do
  case "${flag}" in
    e) EDITOR_COMMAND=${OPTARG} ; shift; shift ;;
    *);;
  esac
done

# exit if parameter is not executable
if [[ ! -x "$(which "$EDITOR_COMMAND")" ]]; then echo "$EDITOR_COMMAND is not executable"; exit 1; fi

source "$SCRIPTS_LIB_FOLDER/menu.sh"
