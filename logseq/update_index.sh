#!/bin/bash
PATH=/home/matteo/appunti
ls  "$PATH" | while read REPO ;do
 ./create_index.sh /home/matteo/appunti/"$REPO"
done