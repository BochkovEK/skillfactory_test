source ./source.bash

echo "FAVICONS_DIR: $FAVICONS_DIR"
echo "FAVICONS_SCRIPT: $FAVICONS_SCRIPT"
echo "IMAGE_TAG: $IMAGE_TAG"
echo "CONTAINER_NAME: $CONTAINER_NAME"
echo "DOMAIN": ${1}

mkdir -p $FAVICONS_DIR

container_run () {
    echo "Run container $CONTAINER_NAME with parm: ${1}"
    docker run -d \
    -v $FAVICONS_DIR:$FAVICONS_DIR \
    -e DOMAIN=${1} \
    $IMAGE_TAG
}

if [ -z "$(docker images -q $IMAGE_TAG 2> /dev/null)" ]; then
  echo "Build image: $IMAGE_TAG"
  docker build . \
  --build-arg FAVICONS_DIR=${FAVICONS_DIR} \
  --build-arg FAVICONS_SCRIPT=${FAVICONS_SCRIPT} \
  -t $IMAGE_TAG

  container_run ${1}
else
  container_run ${1}
fi

ls -la $FAVICONS_DIR
