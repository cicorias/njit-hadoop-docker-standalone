# Hadoop 3 Docker Image
A minimal Hadoop 3.2.x image (currently version 3.2.1)

## Building Image Locally
Example building this image with name "hadoop-3":
```
docker build -t hadoop-3 .
```
## Create and Run Container from Local Build
Create container named "hadoop-3", map container port 8080 to host port 8080, set to delete container after shut down:
```   
docker run --rm -p 8088:8088 --name hadoop-3 -d hadoop-3
```

# Use the Docker hub version
You can avoid building and just run the image up on [Docker hub](https://hub.docker.com/repository/docker/cicorias/hadoop-docker-3).

From a Shell or prompt where you have Docker installed:

```
docker run --rm -p 8088:8088 --name hadoop cicorias/hadoop-docker-3:latest
```

## Test Hadoop Installation
Run sample MapReduce job to test installation:
```bash
    # start interactive shell in running container
    docker exec -it hadoop-3 bash

    # once shell has started run hadoop "pi" example job
    hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.1.jar pi 10 100
```


