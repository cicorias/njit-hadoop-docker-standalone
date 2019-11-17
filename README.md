# Hadoop 3 Docker Image
A minimal Hadoop 3.2.x image (currently version 3.2.1)

## Building Image
Example building this image with name "hadoop-3":

    docker build -t hadoop-3 .

## Create and Run Container
Create container named "hadoop-3", map container port 8080 to host port 8080, set to delete container after shut down:
   
    docker run --rm -p 8088:8088 --name hadoop-3 -d hadoop-3

## Test Hadoop Installation
Run sample MapReduce job to test installation:

    # start interactive shell in running container
    docker exec -it hadoop-3 bash

    # once shell has started run hadoop "pi" example job
    hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.1.jar pi 10 100

