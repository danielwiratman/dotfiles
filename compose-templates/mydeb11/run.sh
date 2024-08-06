#!/bin/bash

read -p "Container name: " CONTAINER_NAME

COMMAND="docker run -d --name $CONTAINER_NAME --hostname mydeb11 --network host mydeb11"

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
