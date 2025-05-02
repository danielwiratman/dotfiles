#!/bin/bash

read -p "Container name: " CONTAINER_NAME

COMMAND="docker run -dit --name $CONTAINER_NAME --network host mydeb11"

echo "Command:"
echo $COMMAND
echo

$COMMAND
