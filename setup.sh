#!/bin/bash

VERSION=latest

# add fast repo info
rm -rf /etc/yum.repos.d/*
curl -sL -o /etc/yum.repos.d/aitac-centos.repo https://raw.githubusercontent.com/irixjp/aitac-automation-handson/master/roles/set_fast_repo/files/aitac-centos.repo

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

PUB_IP=`curl -s http://169.254.169.254/latest/meta-data/public-ipv4`
echo ''
echo ''
echo 'Access to the below url'
echo '###############################################################'
echo ''
docker logs jupyter 2>&1 | grep "     http://localhost:8888/?token=" | tail -1 | sed -e s/localhost/${PUB_IP:?}/g
echo ''
echo '###############################################################'
echo ''
echo ''
