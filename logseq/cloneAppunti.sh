#!/bin/bash
mkdir "$HOME"/appunti
echo "cloning repositories"
echo "----------------------"
cat repo_appunti |while read REPO ; do
    git clone "$REPO" "$HOME"/appunti/$(echo $REPO |rev| cut -d/ -f1 |rev |cut -d. -f1)
done
