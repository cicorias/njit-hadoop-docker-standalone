FROM ubuntu:16.04

# set environment vars
ENV HADOOP_HOME /opt/hadoop
ENV MVN_HOME /opt/maven
ENV OOZIE_HOME /opt/oozie
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# install packages
RUN \
  apt-get update && apt-get install -y \
  ssh \
  rsync \
  vim \
  openjdk-8-jdk


# download and extract hadoop, set JAVA_HOME in hadoop-env.sh, update path
RUN \
  wget -q http://apache.mirrors.tds.net/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz && \
  tar -xzf hadoop-3.2.1.tar.gz && \
  mv hadoop-3.2.1 $HADOOP_HOME && \
  echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

RUN \
  wget -q https://dist.apache.org/repos/dist/release/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz && \
  tar -xzf apache-maven-3.6.3-bin.tar.gz && \
  mv apache-maven-3.6.3 $MVN_HOME

RUN \
  wget -q https://dist.apache.org/repos/dist/release/oozie/5.1.0/oozie-5.1.0.tar.gz && \
  tar -xzf oozie-5.1.0.tar.gz && \
  mv oozie-5.1.0 $OOZIE_HOME
   
RUN \
  echo "PATH=$PATH:$HADOOP_HOME/bin:$MVN_HOME/bin:$OOZIE_HOME/bin" >> ~/.bashrc


ENV PATH="${PATH}:$HADOOP_HOME/bin:$MVN_HOME/bin:$OOZIE_HOME/bin"

# RUN \
#   $OOZIE_HOME/bin/mkdistro.sh -DskipTests -P hadoop-3
RUN \
  $OOZIE_HOME/bin/mkdistro.sh -DskipTests -Puber -Phadoop-3

# create ssh keys
RUN \
  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys

# copy hadoop configs
ADD configs/*xml $HADOOP_HOME/etc/hadoop/

# copy ssh config
ADD configs/ssh_config /root/.ssh/config
RUN chmod 0600 /root/.ssh/config


# copy script to start hadoop
ADD start-hadoop.sh start-hadoop.sh

# expose various ports
EXPOSE 8088 50070 50075 50030 50060

STOPSIGNAL SIGINT

# start hadoop
CMD bash start-hadoop.sh
