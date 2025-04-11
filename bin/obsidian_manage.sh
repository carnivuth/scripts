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
FLAGS_STRING="i:s:b:v:p:f:t:n:rgu"
declare -A FLAGS
FLAGS[v]='VAULT=${OPTARG}'
FLAGS[p]='PROP=${OPTARG}'
FLAGS[g]='GIT_INIT="TRUE"'
FLAGS[f]='FROM=${OPTARG}'
FLAGS[t]='TO=${OPTARG}'
FLAGS[r]='RESET="TRUE"'
FLAGS[i]='START_INDEX=${OPTARG}'
FLAGS[s]='BUMP_VALUE=${OPTARG}'
FLAGS[n]='NOTE=${OPTARG}'

# COMMANDS
declare -A COMMANDS

COMMANDS[convert_to]="convert pages to other formats"
COMMANDS[merged_md]="create a md file with all notes linked"
COMMANDS[create]="create a new vault with default configs and git"
COMMANDS[update]="update all known vaults to obsidian with default configs in $OBSIDIAN_CONFIGS"
COMMANDS[index]="create an index.md file with the list of the first page of each argument in the repo"
COMMANDS[add_footer]="add footer to an obsidian page using index prop"
COMMANDS[prop]="show prop status"
COMMANDS[push]="push content to remotes"
COMMANDS[link]="check if link of a file are broken"
COMMANDS[bulk_index]="rewrite indexes in all repo"

function link(){

  if [[ ! -d ".obsidian" ]];then echo "$(pwd) is not an obsidian vault run inside one"; exit 1; fi
  if [[ "$NOTE" == '' ]];then echo "note file is required run with -n '[path to file]'"; exit 1; fi

  ## Extract link and test if link is broken
  grep -E "\[.*\]\(.+\)" "$NOTE" | grep -vP '\!\[' | grep -oP '\]\(\K[^\)]+(?=\))' | while read link; do
    if [[ $link =~ "http" ]]; then
      curl $link > /dev/null 2>&1 || echo $link
    else
      file="$(echo $link | awk -F'#' '{print $1}' )"
      test -z $file || test -f "pages/$file" || test -f "assets/$file" || echo $file
    fi
  done
}

function bulk_index(){
  # check for correct directory
  if [[ ! -d ".obsidian" ]];then echo "$(pwd) is not an obsidian vault run inside one"; exit 1; fi
  if [[ "$START_INDEX" == '' ]];then echo "start index is required run with -i '[NUM]'"; exit 1; fi
  if [[ "$BUMP_VALUE" == '' ]];then echo "bump value is required run with -s '[NUM]'"; exit 1; fi

  grep index: $ARGUMENTS_FOLDER/*.md $ARGUMENTS_FOLDER/**/*.md 2>/dev/null | awk -F':' '{print $3 " " $1}' | sort -b -g | while read index file; do
  if [[ "$index" -gt "$START_INDEX" ]];then
    newindex=$(( "$index" + "$BUMP_VALUE" ))
    echo "change index of $file from $index to $newindex"
    sed -i "s/index:.*/index: $newindex/g" "$file"
  fi
  done
}

function prop(){
  # check for correct directory
  if [[ ! -d ".obsidian" ]];then echo "$(pwd) is not an obsidian vault run inside one"; exit 1; fi
  if [[ "$PROP" == '' ]];then echo "property is required run with -p 'prop_name'"; exit 1; fi
  echo "pages with $PROP"
  grep "$PROP:" $ARGUMENTS_FOLDER/*.md $ARGUMENTS_FOLDER/**/*.md 2>/dev/null | awk -F':' '{print $3 " " $1}' | sort -b -g | while read -r prop file; do
    echo "$file $prop"
  done
  echo "pages without $PROP"
  grep "$PROP:" $ARGUMENTS_FOLDER/*.md $ARGUMENTS_FOLDER/**/*.md -L 2>/dev/null | awk -F':' '{print $3 " " $1}' | sort -b -g | while read -r file; do
    echo "$file"
  done
}

function merged_md(){

  outfile=merged.md
  # check for correct directory
  if [[ ! -d ".obsidian" ]];then echo "$(pwd) is not an obsidian vault run inside one"; exit 1; fi
  rm -f "$outfile"
  grep index: $ARGUMENTS_FOLDER/*.md $ARGUMENTS_FOLDER/**/*.md 2>/dev/null | awk -F':' '{print $3 " " $1}' | sort -b -g | while read index file; do
  if [[ -f "$file" ]];then echo "![$(basename $file)]($file)" >> "$outfile"; fi
done
echo "created $outfile"
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

function add_footer(){

  # check for correct directory
  if [[ ! -d ".obsidian" ]];then echo "$(pwd) is not an obsidian vault run inside one"; exit 1; fi

  for file in $ARGUMENTS_FOLDER/*.md $ARGUMENTS_FOLDER/**/*.md; do
    if [[ -f "$file" ]];then

      sed -i '/\[PREVIOUS\]/d' "$file"
      sed -i '/\[NEXT\]/d' "$file"
      sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$file"

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
        prec_file="$( grep -xl "index: $prec" $ARGUMENTS_FOLDER/*.md $ARGUMENTS_FOLDER/**/*.md 2>/dev/null)"
        next_file="$( grep -xl "index: $next" $ARGUMENTS_FOLDER/*.md $ARGUMENTS_FOLDER/**/*.md 2>/dev/null)"

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
    fi
  done
}

# create an index file with a link to the first page of an argument using the index obsidian properties
# usefull for quartz site generation
function index(){

  index=index.md
  newindex=index.new.md

  # check for correct directory
  if [[ ! -d ".obsidian" ]];then echo "$(pwd) is not an obsidian vault run inside one"; exit 1; fi

  PROJECT_NAME="$(basename $(pwd) | tr '[:lower:]' '[:upper:]' | sed 's/_/ /g')"
  echo -e "# $PROJECT_NAME\n\n## CONTENTS" > "$newindex"

  grep index: $ARGUMENTS_FOLDER/*.md $ARGUMENTS_FOLDER/**/*.md 2>/dev/null | awk -F':' '{print $3 " " $1}' | sort -b -g | while read index file; do
  if [[ -f "$file" ]];then echo "- [$(basename $file '.md' | tr '[:upper:]' '[:lower:]' )]($file)" >> "$newindex"; fi
done
if [[ ! -f "$index" ]];then mv "$newindex" "$index"; echo "created $index"; fi
if [[ -f "$index" ]];then nvim -d "$index" "$newindex";rm "$newindex"; fi
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

  for file in $ARGUMENTS_FOLDER/**/*.md $ARGUMENTS_FOLDER/*.md ; do
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
