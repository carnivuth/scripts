#!/bin/bash
#
# OBSIDIAN COMMAND UTILS FOR MANAGING VAULTS CONFIGS AND SOME BORING TASKS
#
# credits: carnivuth (matteo longhi)

source "$HOME/.config/scripts/settings.sh"

#set -x
OBSIDIAN_CONFIGS="$SCRIPTS_LIB_FOLDER/obsidian_configs"

function help_command(){
  echo "usage: $(basename "$0") -v vault_path -[gr] -> init new vault by resetting obsidian configs or initializing git repo"
  echo "       $(basename "$0") -u -> update obsidian configuration on all vaults known by obsidian"
  echo "       $(basename "$0") -h -> print this message"
  exit 0
}

function update_vaults(){
  # exit if file is absent or is not link
  if [[ ! -L "$OBSIDIAN_CONFIGS" ]]; then echo "$OBSIDIAN_CONFIGS is not a link or is not present"; exit 1; fi

  # loop obsidian known vaults and run this script with -v -r flags
  jq -r '.vaults[].path' "$HOME/.config/obsidian/obsidian.json" | while read -r vault; do
    if [[ -d "$vault" ]]; then
      echo "updating $vault"
      $0 -v "$vault" -r
    fi
  done
}

while getopts v:rghu flag; do
  case "${flag}" in
    v) VAULT=${OPTARG} ;;
    g) GIT_INIT='TRUE' ;;
    r) RESET='TRUE' ;;
    u) update_vaults ; exit 0 ;;
    h) help_command; exit 0 ;;
    *) echo "flag $flag not supported"; help_command; exit 1 ;;
  esac
done

# check for vault variable
if [[ "$VAULT" == '' ]];then echo "no -u or -h options: path to vault is required"; help_command; exit 1; fi

# creating dirs and subdirs
mkdir -p "$VAULT"
mkdir -p "$VAULT/journals"
mkdir -p "$VAULT/assets"
mkdir -p "$VAULT/pages"

if [[ ! -d "$VAULT/.obsidian"  ]] || [[ "$RESET" == 'TRUE' ]]; then
  echo "resetting $VAULT obsidian configs"
  rm -rf "$VAULT/.obsidian"
  cp -Lr "$OBSIDIAN_CONFIGS" "$VAULT/.obsidian"
fi

# create git repo
if [[ "$GIT_INIT" == 'TRUE' ]] || [[ ! -d "$VAULT/.git" ]]; then
  cd "$VAULT" || exit 1;
  echo "initializing git repository in $VAULT"
  git init
  echo 'workspace.json' > "$VAULT/.gitignore"
fi
