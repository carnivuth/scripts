#!/bin/bash
# script for cloning all repos from a specific account
# import defaults
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_HOME_FOLDER/carnivuth-DE/rofi/github-repoviewer/account.sh"

curl https://api.github.com/users/$account/repos | jq -r '.[] | .html_url'| while read url; do
echo "cloning $url"
git clone "$url"
done
