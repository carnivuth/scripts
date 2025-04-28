#!/bin/bash
# menu main script
# the script relies on the existance of menu component X.sh with the following function defined:
# list_X that need to list the content for the menu display in the form X:<CONTENT>
# run_X function that will be run after the selected element is detected, the element is passed in the form <CONTENT>

source "$HOME/.config/scripts/settings.sh"
PROMPT="carni-launcher"

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

# get menu backend
if [[ -f "$SCRIPTS_LIB_FOLDER/$MENU_BACKEND"_standard.sh ]] ; then
  source "$SCRIPTS_LIB_FOLDER/$MENU_BACKEND"_standard.sh;
else
  echo "no backend $MENU_BACKEND found"
  exit 1
fi

# get filters
menus=''
if [[ -n $@ ]];then
  for m in "$@";do
    if [[ -z $menus ]];then
      menus="-name $m.sh"
    else
      menus="$menus -or -name $m.sh"
    fi
  done
fi

# print elements
chosen="$(find $SCRIPTS_LIB_FOLDER/menus/ -name '*.sh' $menus | tr ' ' '\n' | parallel 'source {}; list_$(basename {} .sh)' | menu_cmd "$PROMPT" )"
if [[ "$chosen" != '' ]];then
  echo $chosen | awk -F':' '{type = $1; $1=""; print type, $0}' | while read t element; do
  source "$SCRIPTS_LIB_FOLDER/menus/$t.sh"
  run_$t "$element"
done
fi
