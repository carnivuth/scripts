#!/bin/bash
TYPES="cluster-simulation"
help(){

  echo "script for creating projects"
  echo "run with $0 [TYPES] path/to/project "
  echo "with TYPES=$TYPES"
}

cluster-simulation(){
  VENV_PACKAGES="ansible ansible-lint"
  FOLDER="$1"
  cd "$FOLDER"
  echo "creating venv"
  python -m venv env
  source env/bin/activate
  echo "installing dev packages in venv"
  pip install $VENV_PACKAGES
  pip freeze > requirements.txt
  echo env > .gitignore
  echo "init git repository"
  git init

}

create(){
  TYPE="$1"
  FOLDER="$2"
  echo "creating $FOLDER"
  echo
  mkdir -p "$FOLDER"
  if [[ "$TYPES" =~ "$TYPE" ]];then
          "$TYPE" "$FOLDER"
  else
          help
  fi
}

if [[ "$#" -lt 3 ]]; then 
  help 
  exit 1
fi
case "$1" in
  create)
    shift 
    create "$@"
    ;;
  *)
    help
    ;;
esac
