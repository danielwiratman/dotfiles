#!/bin/bash

read -p "Container name: " CONTAINER_NAME

COMMAND="docker exec -it -u user1 $CONTAINER_NAME /bin/bash"

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
