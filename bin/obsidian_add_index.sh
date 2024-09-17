#!/bin/bash
# the script dinamically creates an index file with a link to the first page of an argument using the index obsidian properties
ARGUMENTS_FOLDER="pages"

# check for correct directory
if [[ ! -d ".obsidian" ]];then echo "run in an obsidian vault"; exit 1; fi
# check input parameter
if [[ $# != 1 ]]; then echo "project name is required"; exit 1; fi
PROJECT_NAME="$1"

echo -e "# $PROJECT_NAME\n## CONTENTS" > index.md

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
