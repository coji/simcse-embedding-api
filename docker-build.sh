#!/bin/sh

docker build -t simcse-embedding-api .
docker tag simcse-embedding-api coji/simcse-embedding-api:latest  
