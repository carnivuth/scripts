#!/bin/bash
# function for checking if other functions are callable
check_if_function_exist(){
  if [[ "$(type -t "$1")" != "function" ]]; then echo "$1 is not defined"; exit 1;fi
}
