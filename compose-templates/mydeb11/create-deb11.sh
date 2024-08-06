#!/bin/bash

read -p "Enter container name: " CONTAINER_NAME

docker run -d --name $CONTAINER_NAME --hostname debian11 --label ru.grachevko.dhu=$CONTAINER_NAME.local mydeb11 /bin/bash -c "tail -f /dev/null"

CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$CONTAINER_NAME")

echo "The IP address of the container is: $CONTAINER_IP"
