#!/bin/bash

VERSION=latest

# add fast repo info
rm -rf /etc/yum.repos.d/*
curl -sL -o /etc/yum.repos.d/aitac-centos.repo https://raw.githubusercontent.com/irixjp/aitac-automation-handson/master/aitac-centos.repo

# clear repo metadata
yum clean all
yum repolist

# install docker
yum install -y docker

# enable & start docker
systemctl enable docker
systemctl start docker

# wait docker start
sleep 10
docker version

# pull & run docker images
docker run -d -p 8888:8888 --name jupyter -e TZ=JST-9 irixjp/aitac-automation:${VERSION:?}
sleep 10

# add handson contents into the container
docker exec jupyter git clone https://github.com/irixjp/aitac-automation-handson.git

echo ''
echo ''
echo 'Access to the below url'
echo '###############################################################'
echo ''
echo `docker logs jupyter 2>&1 | grep "all ip addresses on your system" | grep "/?token=" | tail -1`
echo ''
echo '###############################################################'
echo ''
echo ''
