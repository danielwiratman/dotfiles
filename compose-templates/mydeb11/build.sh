#!/bin/bash

IMAGE_NAME=mydeb11:latest
COMMAND="docker buildx build -t $IMAGE_NAME ."

echo "Command:"
echo $COMMAND
echo
echo "Execute ([y]/n)?"
read -r execute

if [ "$execute" = "n" ]; then
  echo "Aborted."
  exit 1
fi

$COMMAND
