#!/bin/bash
source "$HOME/scripts/settings.sh"
set -x

while getopts v:rghu flag; do
  case "${flag}" in
    v) VAULT=${OPTARG} ;;
    h) PRINT_HELP="TRUE" ;;
    g) GIT_INIT='TRUE' ;;
    r) RESET='TRUE' ;;
    u) UPDATE='TRUE' ;;
    *) echo "flag $flag not supported"; exit 1 ;;
  esac
done

# print help message
if [[ "$PRINT_HELP" == 'TRUE' ]]; then
  echo "usage $0 -v vault_path -[grh]"
  exit 0
fi

# updating vaults with the latest configs and exit
if [[ "$UPDATE" == 'TRUE' ]] && [[ -f "$HOME/.config/obsidian/obsidian.json" ]]; then
  jq -r '.vaults[].path' "$HOME/.config/obsidian/obsidian.json" | while read -r vault; do
  if [[ -d "$vault" ]]; then
    echo "updating $vault"
    $0 -v "$vault" -r
  fi
done
exit 0
fi

# check for vault variable
if [[ "$VAULT" == '' ]];then echo "path to vault is required"; exit 1; fi

mkdir -p "$VAULT"
mkdir -p "$VAULT/journals"
mkdir -p "$VAULT/assets"
mkdir -p "$VAULT/pages"

if [[ ! -d "$VAULT/.obsidian"  ]] || [[ "$RESET" == 'TRUE' ]]; then
  rm -rf "$VAULT/.obsidian"
  cp -r "$SCRIPTS_VAR_FOLDER/.obsidian" "$VAULT"
fi

# create git repo
if [[ "$GIT_INIT" == 'TRUE' ]] || [[ ! -d "$VAULT/.git" ]]; then
  cd "$VAULT" || exit 1;
  git init
  echo 'workspace.json' >"$VAULT/.gitignore"
fi
