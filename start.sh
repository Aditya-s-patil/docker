#!/bin/sh
docker pull 192.168.29.103/mastek/dockercomposeimg:v1
docker run --name temp_container 192.168.29.103/mastek/dockercomposeimg:v1
docker cp temp_container:/buildapp ./
docker stop temp_container
docker rm temp_container

docker pull 192.168.29.103/mastek/widget:v1
docker pull 192.168.29.103/mastek/genaiserver:v1

# Run docker-compose
docker-compose up
