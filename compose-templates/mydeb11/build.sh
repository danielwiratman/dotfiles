#!/bin/bash

IMAGE_NAME=mydeb11:latest
COMMAND="docker buildx build -t $IMAGE_NAME ."

echo "Command:"
echo $COMMAND
echo

$COMMAND
