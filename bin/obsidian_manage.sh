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
FLAGS_STRING="v:p:f:t:rgu"
declare -A FLAGS
FLAGS[v]='VAULT=${OPTARG}'
FLAGS[p]='PROJECT_NAME=${OPTARG}'
FLAGS[g]='GIT_INIT="TRUE"'
FLAGS[f]='FROM=${OPTARG}'
FLAGS[t]='TO=${OPTARG}'
FLAGS[r]='RESET="TRUE"'

# COMMANDS
declare -A COMMANDS

COMMANDS[convert_to]="convert pages to other formats"
COMMANDS[merged_md]="create a md file with all notes linked"
COMMANDS[create]="create a new vault with default configs and git"
COMMANDS[update]="update all known vaults to obsidian with default configs in $OBSIDIAN_CONFIGS"
COMMANDS[index]="create an index.md file with the list of the first page of each argument in the repo"
COMMANDS[add_footer]="add footer to an obsidian page using index prop"
COMMANDS[push]="push content to remotes"

function merged_md(){

  outfile=merged.md
  # check for correct directory
  if [[ ! -d ".obsidian" ]];then echo "$(pwd) is not an obsidian vault run inside one"; exit 1; fi
  rm -f "$outfile"
  grep index: pages/*.md pages/**/*.md 2>/dev/null | awk -F':' '{print $3 " " $1}' | sort -b -g | while read index file; do
    if [[ -f "$file" ]];then echo "![$(basename $file)]($file)" >> "$outfile"; fi
  done
  echo "created $outfile"
}

function create(){
  # check for vault variable
  if [[ "$VAULT" == '' ]];then echo "path to vault is required run with -v '/path/to/vault'"; exit 1; fi

  # creating dirs and subdirs
  mkdir -p "$VAULT" "$VAULT/journals" "$VAULT/assets" "$VAULT/pages"

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

function add_footer(){

  for file in *.md; do
    sed -i '/\[PREVIOUS\]/d' "$file"
    sed -i '/\[NEXT\]/d' "$file"

    # extract index props
    prec=''
    prec_file=''
    next=''
    next_file=''
    message=''

    index="$( grep 'index:' "$file" |awk -F ' ' '{print $2}')"
    if [[ index != "" ]];then
      # compute prec value and next value
      prec=$(($index - 1))
      next=$(($index + 1))
      echo "prec: $prec"
      echo "index: $index"
      echo "next: $next"

      # grep for prec value and next value
      prec_file="$( grep -xl "index: $prec" *.md)"
      next_file="$( grep -xl "index: $next" *.md)"

      if [[ -f "$prec_file" ]]; then
        message="[PREVIOUS]($prec_file)"
      fi
      if [[ -f "$next_file" ]]; then
        message="$message [NEXT]($next_file)"
      fi
      echo "$message"
      if [[ "$(grep 'NEXT' "$file")" == '' ]] && [[ "$(grep 'PREVIOUS' "$file")" == '' ]]; then
        echo  -e "\n$message" >> $file
      fi
    fi
  done
}

# create an index file with a link to the first page of an argument using the index obsidian properties
# usefull for quartz site generation
function index(){

  # check for correct directory
  if [[ ! -d ".obsidian" ]];then echo "$(pwd) is not an obsidian vault run inside one"; exit 1; fi
  # check input parameter
  if [[ "$PROJECT_NAME" == '' ]];then echo "project name is required use -p flag"; exit 1; fi

  echo -e "# $PROJECT_NAME\n\n## CONTENTS" > index.md

  # add first page of each topic
  subdircount=$(find  $ARGUMENTS_FOLDER -maxdepth 1 -type d | wc -l)
  if [[ "$subdircount" -gt 1 ]]; then
    for file in  $ARGUMENTS_FOLDER/**/*.md; do
      # extract index props
      index="$( grep 'index:' "$file" |awk -F ' ' '{print $2}')"
      if [[ "$index" == "1" ]];then
        # add line to index
        echo "- [$(basename $file .md)]($file)" >> index.md
      fi
    done
  fi

  # add all pages in the ARGUMENTS_FOLDER dir
  subfilescount=$(find  $ARGUMENTS_FOLDER -maxdepth 1 -type f | wc -l)
  if [[ "$subfilescount" -gt 0 ]]; then
    for file in  $ARGUMENTS_FOLDER/*.md; do
      if grep 'index:' "$file";then
        # add line to index
        echo "- [$(basename $file .md)]($file)" >> index.md
      fi
    done
  fi
}

function convert_to(){

  if [[ ! -d ".obsidian" ]];then echo "$(pwd) is not an obsidian vault run inside one"; exit 1; fi

  # check for FROM variable
  if [[ "$FROM" == '' ]];then echo "FROM required run with -f 'format'"; exit 1; fi

  # check for TO variable
  if [[ "$TO" == '' ]];then echo "TO required run with -t 'format'"; exit 1; fi

  DEST_FOLDER="$TO"_converted; if [[ ! -d "$DEST_FOLDER" ]]; then mkdir -p "$DEST_FOLDER"; fi

  if [[ "$FROM" == *.lua ]];then FROM="$SCRIPTS_LIB_FOLDER/$FROM"; fi
  if [[ "$TO" == *.lua ]];then TO="$SCRIPTS_LIB_FOLDER/$TO"; fi

  for file in pages/**/*.md pages/*.md ; do
    if [[ -f "$file" ]]; then
      filename="$(basename "$file" | cut -d '.' -f '1' )"
      echo "converting $filename"
      pandoc -f "$FROM" -t "$TO" "$file" > "$DEST_FOLDER/$filename"
    fi
  done

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
