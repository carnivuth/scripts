#!/bin/bash

# loop files in dir
for file in *.md; do
  index=''
  prec=''
  next=''
  prec_file=""
  next_file=""
  message=""
  # extract index props
  index="$( grep 'index:' "$file" |awk -F ' ' '{print $2}')"
  if [[ index != "" ]];then
    # compute prec value and next value
    prec=$(($index - 1))
    next=$(($index + 1))
    echo "prec: $prec"
    echo "index: $index"
    echo "next: $next"

    # grep for prec value and next value
    prec_file="$( grep -l "index: $prec" *.md)"
    next_file="$( grep -l "index: $next" *.md)"

    if [[ -f "$prec_file" ]]; then
      message="[PREVIOUS]($prec_file)"
    fi
    if [[ -f "$next_file" ]]; then
      message="$message [NEXT]($next_file)"
    fi
    echo "$message"
    if [[ "$(grep 'NEXT' "$file")" == '' ]] && [[ "$(grep 'PREVIOUS' "$file")" == '' ]]; then
      echo  "$message" >> $file
    fi
  fi

done
