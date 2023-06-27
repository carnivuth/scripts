#!/bin/bash
PATH="$HOME"/appunti
ls  "$PATH" | while read REPO ;do
 ./create_index.sh "$HOME"/appunti/"$REPO"
done