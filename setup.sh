#!/bin/bash

VERSION=aitac-2018-v01

# clear repo metadata
yum clean all

# install docker
yum install -y docker

# enable & start docker
systemctl enable docker
systemctl start docker

# pull & run docker images
docker run -d -p 8888:8888 --name jupyter \
           -e TZ=JST-9 \
           irixjp/aitac-automation:${aitac-2018-v01:?}

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
