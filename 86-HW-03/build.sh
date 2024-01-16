#!/bin/bash

source ./source.bash

echo "PHP_TAG: $PHP_TAG"
echo "NGINX_TAG $NGINX_TAG"
echo "COMPOSE_FILE: $COMPOSE_FILE"

echo -E "$COMPOSE_FILE
$NGINX_TAG
$PHP_TAG" > ./.env

docker_compose_up () {
    echo "Docker compose up: $COMPOSE_FILE"
    docker compose -f ./$COMPOSE_FILE up -d
}

docker_compose_down () {
    echo "Docker compose down: $COMPOSE_FILE"
    docker compose -f ./$COMPOSE_FILE down
}

check_and_build_image () {
if [ -z "$(docker images -q ${1} 2> /dev/null)" ]; then
  echo "Build image: ${1}"
  if [ "${1}" = "${PHP_TAG}" ]; then
    docker build . -f ./Dockerfile_php \
    -t ${1}
  elif [ "${1}" = "${NGINX_TAG}" ]; then
    docker build . -f ./Dockerfile_nginx \
    -t ${1}
  fi
fi
}

check_and_build_image $PHP_TAG
check_and_build_image $NGINX_TAG

if [ -z "$(docker ps| grep -e "php|nginx" 2> /dev/null)" ]; then
  docker_compose_down
  docker_compose_up
else
  docker_compose_up
fi

#container_run