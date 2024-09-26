#!/bin/sh



docker pull 192.168.29.103/mastek/widget:v1
docker pull 192.168.29.103/mastek/genaiserver:v1

# Run docker-compose
docker-compose up
