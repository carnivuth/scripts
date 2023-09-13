#!/bin/bash
#function for array parameters import from file 
# $1 absolute path to file with array to import
# $1 example 'ARRAY=("value1" "value2")'
# $2 default value 
array_importer(){
if [ -f "$1" ]; then
    source "$1"
else
    ARRAY=("$2")
fi
}
