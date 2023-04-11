#!/bin/bash
mkdir ~/appunti
echo "cloning repositories"
echo "----------------------"
cat repo_appunti |while read REPO ; do
    git clone "$REPO" ~/appunti/$(echo $REPO |rev| cut -d/ -f1 |rev |cut -d. -f1)
done
