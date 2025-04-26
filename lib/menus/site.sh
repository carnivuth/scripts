#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/launch_webapp.sh"

list_site(){
  jq -r '.[].site' $SCRIPTS_VAR_FOLDER/sites.json.d/*.json "$SCRIPTS_VAR_FOLDER/sites.json" | sed 's/^/site:/'
}

run_site(){
  site="$( jq -r ".[] | select(.site == \"$1\")| .link " $SCRIPTS_VAR_FOLDER/sites.json.d/*.json "$SCRIPTS_VAR_FOLDER/sites.json" )"
  if [[ "$site" != '' ]];then
    launch_webapp "$site"
  fi
}
