#!/usr/bin/env bash

docker build -t hadoop . && \
docker run -it --rm -p 11000-11001:11000-11001 -p 8088:8088 hadoop bash
