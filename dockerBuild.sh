#!/bin/bash
#Build docker image and run container on Jenkin + GitLab
DOCKER_IMAGE=keepwalking/nginx_laravel
DOCKER_CONTAINER=nginx_laravel

#Build image
docker build -t ${DOCKER_IMAGE} .
#Check port exists
netstat -nta |grep -i listen |awk -F " " '{print $4}' |grep ":8081$" &>/dev/null
if [[ $? -eq 0 ]]; then
    echo -n $PORTS; echo " ports are existing. Please, use other ports"
    exit 0;
else
    #Check container exists
    CONTAINER_ID=`docker ps -a | grep $DOCKER_CONTAINER | grep "Up" | awk -F " " '{ print $1 }'`
    if [[ $CONTAINER_ID != "" ]]; then
        exit 0;
    else
        docker ps -a | awk '{print $NF}' |grep $DOCKER_CONTAINER &>/dev/null
        if [[ $? -ne 0 ]]; then
            docker run -d -p 8081:80 -v `pwd`/src:/var/www/example --name ${DOCKER_CONTAINER} ${DOCKER_IMAGE}
        else
            #remove docker container that not running
            docker rm -f ${DOCKER_CONTAINER}
            #create & rung docker container
	        docker run -d -p 8081:80 -v `pwd`/src:/var/www/example --name ${DOCKER_CONTAINER} ${DOCKER_IMAGE}
        fi
    fi
fi