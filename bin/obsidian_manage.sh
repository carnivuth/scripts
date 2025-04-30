#!/bin/bash
#
# OBSIDIAN COMMAND UTILS FOR MANAGING VAULTS CONFIGS AND SOME BORING TASKS
#
# credits: carnivuth (matteo longhi)

source "$HOME/.config/scripts/settings.sh"

# GLOBAL VARS
OBSIDIAN_CONFIGS="$SCRIPTS_LIB_FOLDER/obsidian_configs"
ARGUMENTS_FOLDER="pages"

# FLAGS
FLAGS_STRING="b:v:p:t:n:rgu"
declare -A FLAGS
FLAGS[v]='VAULT=${OPTARG}'
FLAGS[p]='PROP=${OPTARG}'
FLAGS[g]='GIT_INIT="TRUE"'
FLAGS[t]='TO=${OPTARG}'
FLAGS[r]='RESET="TRUE"'
FLAGS[n]='NOTE=${OPTARG}'

# COMMANDS
declare -A COMMANDS

COMMANDS[convert_to]="convert pages to other formats"
COMMANDS[create]="create a new vault with default configs and git"
COMMANDS[update]="update all known vaults to obsidian with default configs in $OBSIDIAN_CONFIGS"
COMMANDS[add_footer]="add footer to an obsidian page using index prop"
COMMANDS[prop]="show prop status"
COMMANDS[push]="push content to remotes"
COMMANDS[link]="check if link of a file are broken"

function pwd_is_obsidian_vault(){
  if [[ ! -d ".obsidian" ]];then echo "$(pwd) is not an obsidian vault run inside one"; return 1; fi
}


function link(){

  pwd_is_obsidian_vault || exit 1

  if [[ "$NOTE" == '' ]];then echo "note file is required run with -n '[path to file]'"; exit 1; fi

  ## Extract link and test if link is broken
  grep -E "\[.*\]\(.+\)" "$NOTE" | grep -vP '\!\[' | grep -oP '\]\(\K[^\)]+(?=\))' | while read link; do
    if [[ $link =~ "http" ]]; then
      curl $link > /dev/null 2>&1 || echo $link
    else
      file="$(echo $link | awk -F'#' '{print $1}' )"
      test -z $file || test -f "$file" || echo $file
    fi
  done
}

function prop(){

  pwd_is_obsidian_vault || exit 1
  if [[ "$PROP" == '' ]];then echo "property is required run with -p 'prop_name'"; exit 1; fi

  grep "$PROP:" $(find $ARGUMENTS_FOLDER -type f -name '*.md') 2>/dev/null | awk -F':' '{print $3 " " $1}' | sort -b -g | while read -r prop file; do
    echo "$file $prop"
  done

  grep "$PROP:" $ARGUMENTS_FOLDER/*.md $ARGUMENTS_FOLDER/**/*.md -L 2>/dev/null | awk -F':' '{print $3 " " $1}' | sort -b -g | while read -r file; do
    echo "$file: undefined $PROP"
  done
}

function create(){

  # check for vault variable
  if [[ "$VAULT" == '' ]];then echo "path to vault is required run with -v '/path/to/vault'"; exit 1; fi

  # creating dirs and subdirs
  mkdir -p "$VAULT" "$VAULT/templates" "$VAULT/journals" "$VAULT/assets" "$VAULT/$ARGUMENTS_FOLDER"

  # reset obsidian configs
  if [[ ! -d "$VAULT/.obsidian"  ]] || [[ "$RESET" == 'TRUE' ]]; then
    echo "resetting $VAULT obsidian configs"
    rm -rf "$VAULT/.obsidian"
    cp -Lr "$OBSIDIAN_CONFIGS" "$VAULT/.obsidian"
  fi

  # create git repo
  if [[ "$GIT_INIT" == 'TRUE' ]]; then
    cd "$VAULT" || exit 1;
    echo "initializing git repository in $VAULT"
    git init
    echo 'workspace.json' > "$VAULT/.gitignore"
  fi
}

function update(){
  # exit if file is absent or is not link
  if [[ ! -L "$OBSIDIAN_CONFIGS" ]]; then echo "$OBSIDIAN_CONFIGS is not a link or is not present"; exit 1; fi

  # loop obsidian known vaults and run this script with -v -r flags
  jq -r '.vaults[].path' "$HOME/.config/obsidian/obsidian.json" | while read -r vault; do
  if [[ -d "$vault" ]]; then
    echo "updating $vault"
    $0 create -v "$vault" -r
  fi
done
}

# based on the props next: and previous in the following format
# previous: full/path/to/file
# next: full/path/to/file
function add_footer(){

  pwd_is_obsidian_vault || exit 1

  for file in $(find $ARGUMENTS_FOLDER -type f -name '*.md'); do

      # remove old links
      sed -i '/\[PREVIOUS\]/d' "$file"
      sed -i '/\[NEXT\]/d' "$file"
      sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$file"

      # extract index props
      previous="$( grep 'previous:' "$file" |awk -F ' ' '{print $2}'| sed 's/"//g')"
      next="$( grep 'next:' "$file" |awk -F ' ' '{print $2}' | sed 's/"//g')"

        if [[ -f "$previous" ]]; then
          echo "[PREVIOUS]($previous)" >> "$file"
        fi
        if [[ -f "$next" ]]; then
          echo "[NEXT]($next)" >> "$file"
        fi
  done
}

function convert_to(){

  pwd_is_obsidian_vault || exit 1

  # check for TO variable
  if [[ "$TO" == '' ]];then echo "TO required run with -t 'format'"; exit 1; fi

  DEST_FOLDER="$TO"_converted; if [[ ! -d "$DEST_FOLDER" ]]; then mkdir -p "$DEST_FOLDER"; fi

  if [[ "$TO" == *.lua ]];then TO="$SCRIPTS_LIB_FOLDER/$TO"; fi

  export OBSIDIAN_MANAGE_TO="$TO"
  export OBSIDIAN_MANAGE_DEST_FOLDER="$DEST_FOLDER"
  find "$ARGUMENTS_FOLDER" -type f -name '*.md' | parallel --eta 'filename="$(basename "{}" .md)"; echo "converting $filename"; pandoc -f "gfm" -t "$OBSIDIAN_MANAGE_TO" "{}" > "$OBSIDIAN_MANAGE_DEST_FOLDER/$filename"'

}

function push(){

  # loop obsidian known vaults and run git push
  jq -r '.vaults[].path' "$HOME/.config/obsidian/obsidian.json" | while read -r vault; do
  if [[ -d "$vault" ]]; then
    # pull remote
    (cd "$vault" && git pull)

    # commit obsidian files if changes is present
    if  cd "$vault" && git status | grep '.obsidian' ; then
      echo "$vault committing obsidian files "
      (cd "$vault" && git add ".obsidian" && git commit -m "updated obsidian files")
    fi

    # push files
    echo "$vault pushing to remote"
    (cd "$vault" && git push)

  fi
done
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
