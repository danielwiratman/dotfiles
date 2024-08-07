#!/bin/bash

echo "Command:"
echo "docker exec -it -u user1 <container-name> bash"
echo
echo "Execute? (y/[n])"
read -r choice

if [ "$choice" = "y" ]; then
  read -p "Container name: " container
  echo "docker exec -it -u user1 $container bash"
  echo
  docker exec -it -u user1 $container bash
fi
