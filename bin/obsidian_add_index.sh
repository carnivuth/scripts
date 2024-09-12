#!/bin/bash
# loop files in dir
# the script dinamically creates an index file with a link to the first page of an argument using the index obsidian properties
ARGUMENTS_FOLDER="pages"

if [[ $# != 1 ]]; then echo "project name is required"; exit 1; fi
PROJECT_NAME="$1"

# check for correct directory
if [[ ! -d ".obsidian" ]];then echo "run in an obsidian vault"; exit 1; fi

echo "# $PROJECT_NAME" > index.md
echo "## CONTENTS" >> index.md

for file in $ARGUMENTS_FOLDER/**/*.md; do
  # extract index props
  index="$( grep 'index:' "$file" |awk -F ' ' '{print $2}')"
  if [[ "$index" == "1" ]];then
    # add line to index
    echo "- [$(basename $file .md)]($file)" >> index.md

  fi

done
