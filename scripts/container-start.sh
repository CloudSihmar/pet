#!/bin/bash
sleep 5
docker run -d --name spring-petclinic -p 8080:8080 cloudsihmar/spring-petclinic:latest
