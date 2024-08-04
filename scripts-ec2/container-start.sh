#!/bin/bash
sleep 5
REPOSITORY_URI="685421549691.dkr.ecr.ap-south-1.amazonaws.com/pet"
IMAGE_TAG="latest"
docker run -d --name spring-petclinic -p 9090:8080 $REPOSITORY_URI:$IMAGE_TAG
