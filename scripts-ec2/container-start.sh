#!/bin/bash
sleep 5
REPOSITORY_URI="cloudsihmar/spring-petclinic"
IMAGE_TAG="latest"
docker run -d --name spring-petclinic -p 9090:8080 $REPOSITORY_URI:$IMAGE_TAG
