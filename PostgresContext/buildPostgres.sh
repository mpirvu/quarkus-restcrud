#!/bin/sh
docker build -f Dockerfile -t restcrud-db .
#podman run -d --name pgdocker --rm --net myNetwork --ip 192.168.200.10 restcrud-db

