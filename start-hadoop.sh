#!/bin/bash

_term() { 
  echo "Caught SIGTERM signal!"
  exit 0
}

trap _term SIGINT SIGTERM

# start ssh server
/etc/init.d/ssh start

# format namenode
$HADOOP_HOME/bin/hdfs namenode -format

#setup user
export HDFS_NAMENODE_USER="root"
export HDFS_DATANODE_USER="root"
export HDFS_SECONDARYNAMENODE_USER="root"
export YARN_RESOURCEMANAGER_USER="root"
export YARN_NODEMANAGER_USER="root"

sed 's/mesg n || true/test -t 0 && mesg n/g' /root/.profile > /root/.profile

# start hadoop
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/bin/hdfs dfs -mkdir /user
$HADOOP_HOME/bin/hdfs dfs -mkdir /user/root
$HADOOP_HOME/sbin/start-yarn.sh
#$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver
$HADOOP_HOME/bin/mapred --daemon start historyserver

# keep container running
#tail -f /dev/null
sleep infinity
