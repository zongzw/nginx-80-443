#!/bin/bash 

cdir=`cd $(dirname $0); pwd`
source $cdir/settings

echo cleaning container if exists $container_name
docker rm --force $container_name

if [ -n "$webroot" ]; then 
    volume="-v $webroot:/usr/share/nginx/html"
    command="exec nginx -g 'daemon off;'"
else
    volume=""
    command="echo Nginx Running: \$(hostname) > /usr/share/nginx/html/index.html && exec nginx -g 'daemon off;'"
fi

echo starting container $container_name ..
docker run \
    --name $container_name \
    -itd \
    -p $http_port:80 -p $https_port:443 \
    -v $cdir/conf.d:/etc/nginx/conf.d \
    $volume \
    nginx:latest \
    /bin/bash -c "$command"

sleep 1
docker ps -a | grep $container_name
