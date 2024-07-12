#!/bin/bash

read -p "Enter container name: " CONTAINER_NAME

CONTAINER_ID=$(docker run -d -e POSTGRES_PASSWORD=123123 --name $CONTAINER_NAME postgres:16)

sleep 5

CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_ID)

docker exec -u postgres $CONTAINER_ID bash -c "echo \"listen_addresses = '*'\" >> /var/lib/postgresql/data/postgresql.conf"
docker restart $CONTAINER_ID

echo "PostgreSQL container is running with IP: $CONTAINER_IP"
