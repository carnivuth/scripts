#!/bin/bash
print_menu_list(){
  while read filename; do
    echo "$(echo $filename | rev | cut -d '/' -f 1 | rev )"
  done
}
