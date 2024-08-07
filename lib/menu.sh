#!/bin/bash
# standard menu script structure, all menu script need to implement all function names defined and the variables, then import this script
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/check_if_function_exist.sh";

# check if called function exists
check_if_function_exist list_elements_to_user
check_if_function_exist exec_command_with_chosen_element
check_if_function_exist help_message

standard_help_message(){
  echo "standard parameters for all menus"
  echo "-b menu backend: run under specific menu backend"
  echo "-h: print this message"
}

# get parameter menubackend and import the menu if it does exist
OPTIND=1
while getopts b:h flag; do
  case "${flag}" in
    b) MENU_BACKEND=${OPTARG} ; shift; shift ;;
    h) PRINT_HELP="TRUE" ; shift ;;
    *) echo "${flag} is unsupported" ; exit 1 ;;
  esac
done

if [[ -f "$SCRIPTS_LIB_FOLDER/$MENU_BACKEND"_standard.sh ]] ; then
  source "$SCRIPTS_LIB_FOLDER/$MENU_BACKEND"_standard.sh;
else
  echo "no backend $MENU_BACKEND found"
  exit 1
fi

if [[ "$MENU_NAME" != '' ]]; then menu_theme_setup "$MENU_NAME"; else echo "MENU_NAME is not defined"; exit 1; fi
if [[ "$PROMPT" == '' ]]; then echo "PROMPT is not defined"; exit 1; fi

if [[ "$PRINT_HELP" == 'TRUE' ]]; then
  figlet "$MENU_NAME"
  help_message
  standard_help_message
else

  chosen="$(list_elements_to_user | menu_cmd "$PROMPT" )"
  # focus selected window
  if [[ "$chosen" != '' ]];then
    exec_command_with_chosen_element "$chosen"
  fi
fi
