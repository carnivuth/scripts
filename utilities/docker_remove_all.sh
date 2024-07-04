#!/bin/bash

docker system prune -a -f
docker image prune -a -f
docker volume prune -a -f
docker network prune -f
