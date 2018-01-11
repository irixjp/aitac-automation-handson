#!/bin/bash

VERSION=aitac-2018-v01

# add fast mirror info
echo "prefer=ftp.iij.ad.jp" >> /etc/yum/pluginconf.d/fastestmirror.conf

# clear repo metadata
yum clean all
rm -rf /var/cache/yum

# install docker
yum install -y docker

# enable & start docker
systemctl enable docker
systemctl start docker

sleep 10

# pull & run docker images
docker run -d -p 8888:8888 --name jupyter \
           -e TZ=JST-9 \
           irixjp/aitac-automation:${VERSION:?}

docker exec jupyter "git clone https://github.com/irixjp/aitac-automation-handson.git"

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
