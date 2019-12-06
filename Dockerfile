FROM ubuntu:16.04 AS base

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
  unzip \
  vim \
  openjdk-8-jdk



FROM base AS ooziedist

# build the oozie bits

WORKDIR /root

RUN \
  wget -q https://dist.apache.org/repos/dist/release/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz && \
  tar -xzf apache-maven-3.6.3-bin.tar.gz && \
  mv apache-maven-3.6.3 $MVN_HOME

RUN \
  wget -q https://dist.apache.org/repos/dist/release/oozie/5.1.0/oozie-5.1.0.tar.gz && \
  tar -xzf oozie-5.1.0.tar.gz && \
  mv oozie-5.1.0 $OOZIE_HOME

RUN \
  wget -q http://archive.cloudera.com/gplextras/misc/ext-2.2.zip && \
  unzip ext-2.2.zip -d extjs
   
RUN \
  echo "PATH=$PATH:$MVN_HOME/bin:$OOZIE_HOME/bin" >> ~/.bashrc

ENV PATH="${PATH}:$MVN_HOME/bin:$OOZIE_HOME/bin"

RUN \
  $OOZIE_HOME/bin/mkdistro.sh -DskipTests -Puber -Phadoop-3 -DgenerateDocs


## now the Hadoop image with Oozie to be copied over
RUN echo $OOZIE_HOME/distro/target/

FROM base

COPY --from=ooziedist $OOZIE_HOME/distro/target/oozie-5.1.0-distro/oozie-5.1.0 $OOZIE_HOME
COPY --from=ooziedist /root/ext-2.2.zip $OOZIE_HOME/libext/
ENV PATH="${PATH}:$OOZIE_HOME/bin"

RUN \
  $OOZIE_HOME/bin/oozie-setup.sh


# download and extract hadoop, set JAVA_HOME in hadoop-env.sh, update path
#RUN \
#  wget -q https://dist.apache.org/repos/dist/release/hadoop/common/hadoop-3.2.1/hadoop-3.2.1-src.tar.gz && \
#  tar -xzf hadoop-3.2.1.tar.gz && \
#  mv hadoop-3.2.1 $HADOOP_HOME && \
#  echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

RUN \
  echo "PATH=$PATH:$HADOOP_HOME/bin:$MVN_HOME/bin:$OOZIE_HOME/bin" >> ~/.bashrc

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
EXPOSE 8088 50070 50075 50030 50060 11000 11001 11443

STOPSIGNAL SIGINT

# start hadoop
CMD bash start-hadoop.sh
