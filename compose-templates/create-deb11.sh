#!/bin/bash

read -p "Enter container name: " CONTAINER_NAME

docker run -d --name $CONTAINER_NAME --hostname debian11 --label ru.grachevko.dhu=$CONTAINER_NAME.local debian:11 /bin/bash -c "tail -f /dev/null"

docker exec -it "$CONTAINER_NAME" /bin/bash -c "
    apt-get update &&
    apt-get install -y sudo openssh-server vim nano git &&
    echo 'root:123123' | chpasswd &&
    useradd -m -s /bin/bash user1 &&
    echo 'user1:123123' | chpasswd &&
    usermod -aG sudo user1 &&
    mkdir /var/run/sshd &&
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config &&
    service ssh start
 "

CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$CONTAINER_NAME")
echo "The IP address of the container is: $CONTAINER_IP"
