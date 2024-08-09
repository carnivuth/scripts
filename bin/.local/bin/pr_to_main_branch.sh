#!/bin/bash
# documentation at https://github.com/carnivuth/scripts/blob/main/notes/pages/UPDATE_MAIN_BRANCH.md
branch="$(git branch | grep   '*' | cut -d ' ' -f2)"
if [[ "$branch" == 'main' ]]; then echo 'you are in the main branch, exiting'; exit 0; fi

gh pr create --base 'main' --fill
gh pr merge -m --auto
