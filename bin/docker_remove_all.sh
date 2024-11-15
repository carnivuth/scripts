#!/bin/bash
docker ps | awk -F' ' '{print $1}' | tail -n +2 | xargs docker container kill
docker system prune -a -f
docker image prune -a -f
docker volume prune -a -f
docker network prune -f
