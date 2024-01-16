#!/bin/bash

source ./source.bash

docker stop $(docker ps -a -q)
docker rm $(docker ps -aq)
docker_image_id=$(docker images -q $IMAGE_TAG 2> /dev/null)
docker rmi -f $docker_image_id