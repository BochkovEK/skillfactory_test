#!/bin/bash

source ./source.bash

echo "IMAGE_TAG: $IMAGE_TAG"

container_run () {
    echo "Run container from image: $IMAGE_TAG"
    docker run -d \
    --network host \
    -v /root/build_python3_docker_image/app:/srv/app \
    $IMAGE_TAG
}

if [ -z "$(docker images -q $IMAGE_TAG 2> /dev/null)" ]; then
  echo "Build image: $IMAGE_TAG"
  docker build . \
  -t $IMAGE_TAG

  container_run
else
  container_run
fi