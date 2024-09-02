#!/bin/bash

#set -x
function create_footer(){
  file="$1"
  message=""
  PREC=""
  NEXT=""
  shift
while getopts p:n: flag; do
  case "${flag}" in
    p) PREC=${OPTARG} ;shift;shift ;;
    n) NEXT=${OPTARG} ;shift;shift ;;
    *) echo "flag $flag not supported"; exit 1 ;;
  esac
done
  if [[ ! -f "$file" ]]; then return 1; fi
  if [[ -f "$PREC" ]]; then
    message="[PREVIOUS]($PREC)"
  fi
  if [[ -f "$NEXT" ]]; then
    message="$message [NEXT]($NEXT) "
  fi
  echo "$message"
  if [[ "$(grep 'NEXT' "$file")" == '' ]] && [[ "$(grep 'PREVIOUS' "$file")" == '' ]]; then
    echo  "[PREVIOUS]($PREC) [NEXT]($NEXT)" >> $file
  fi
}

# loop files in dir
for file in *.md; do
  index=''
  prec=''
  next=''
  prec_file=""
  next_file=""
  # extract index props
  index="$( grep 'index:' "$file" |awk -F ' ' '{print $2}')"
  if [[ index != "" ]];then
    # compute prec value and next value
    prec=$(($index - 1))
    next=$(($index + 1))
     echo "index: $index"
     echo "prec: $prec"
     echo "next: $next"

  # grep for prec value and next value
  prec_file="$( grep -l "index: $prec" *.md)"
  next_file="$( grep -l "index: $next" *.md)"
  # create link for prec and next if founded
  echo "create_footer $file -p $prec_file -n $next_file"
  create_footer $file -p $prec_file -n $next_file
  fi

done
