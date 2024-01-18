#!/bin/bash

docker system prune -a
docker image prune -a
docker volume prune -a
docker network prune 
