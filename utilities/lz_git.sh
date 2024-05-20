#!/bin/bash
# check diff and add files for commit
git diff --name-only | fzf --cycle --multi --preview 'git diff {}' | xargs git add
