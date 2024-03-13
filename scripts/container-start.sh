#!/bin/bash
sleep 5
source codedeploy_vars.env
docker run -d --name spring-petclinic -p 9090:8080 $REPOSITORY_URI:$IMAGE_TAG
