#!/bin/bash +x
INDEX="readme.md"
# check parameters
[ ! -d "$1" ] && echo "wrong parameters" && exit 1
[ ! -d "$1/pages" ] && echo "$1 not a logseq folder" && exit 1
[ -f "$INDEX" ] && rm $INDEX
echo '# INDEX' >$INDEX
ls "$1"/pages | while read PAGE; do
    echo " - [$PAGE](<pages/$PAGE>)" >> $INDEX
done
mv "$INDEX" "$1"