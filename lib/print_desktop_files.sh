#!/bin/bash
print_desktop_files(){
  grep -o -e '^Exec=.*' $HOME/.local/share/applications/* /usr/share/applications/*.desktop | awk -F'=' '{print $2}' | awk -F' ' '{print $1}' | sort | uniq | parallel basename
}
