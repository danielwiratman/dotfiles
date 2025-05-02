#!/bin/bash

if [ -n "$1" ]; then
  container="$1"
else
  read -p "Container name: " container
fi

echo "Command:"
echo "docker exec -it -u user1 $container bash"
echo

docker exec -it -u user1 "$container" bash
