#!/bin/bash
help(){

  echo "script for creating ansible project structure with test support, "
  echo "run with $0 create path/to project "
}

create(){
  FOLDER="$1"
  echo "creating $FOLDER"
  echo
  mkdir -p "$FOLDER"
  cd "$FOLDER"
  echo "creating venv"
  echo
  python -m venv env
  source env/bin/activate
  echo "installing dev packages in venv"
  echo
  pip install ansible ansible-lint molecule molecule-plugins[docker] molecule-plugins[vagrant]
  pip freeze > requirements.txt
  echo env > .gitignore
}

if [[ "$#" -ne 2 ]]; then 
  help 
  exit 1
fi
case "$1" in
  create)
    shift 
    create $1
    ;;
  *)
    help
    ;;
esac
