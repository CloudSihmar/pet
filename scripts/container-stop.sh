#!/bin/bash

# Define the container name
container_name="spring-petclinic"

# Check if the container exists
if docker ps -a --format '{{.Names}}' | grep -q "^$container_name$"; then
    # Container exists, so stop and remove it
    docker stop $container_name
    docker rm -f $container_name
else
    echo "Container $container_name not found. Skipping removal."
fi
