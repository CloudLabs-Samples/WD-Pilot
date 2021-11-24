#!/bin/bash

cd /home/hdoop
#source .bashrc
export HADOOP_HOME=/home/hdoop/hadoop-3.2.2
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
export HIVE_HOME="/home/hdoop/apache-hive-3.1.2-bin"
export PATH=$PATH:$HIVE_HOME/bin
export OOZIE_HOME=/home/hdoop/oozie-5.2.1/distro/target/oozie-5.2.1-distro/oozie-5.2.1
export HBASE_HOME=/home/hdoop/hbase
export PATH=$PATH:$HBASE_HOME/bin
export SPARK_HOME=/home/hdoop/spark
export PIG_HOME=/home/hdoop/pig
export PATH=$PATH:$PIG_HOME/bin
export PIG_CLASSPATH=$HADOOP_HOME/etc/hadoop
export HBASE_DISABLE_HADOOP_CLASSPATH_LOOKUP=true

rm /home/hdoop/apache-hive-3.1.2-bin/lib/guava-19.0.jar
cp /home/hdoop/hadoop-3.2.2/share/hadoop/hdfs/lib/guava-27.0-jre.jar /home/hdoop/apache-hive-3.1.2-bin/lib/
#echo -e 'yes' | ssh localhost
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
#exit
echo -e 'Y' | hdfs namenode -format
/home/hdoop/hadoop-3.2.2/sbin/start-dfs.sh
/home/hdoop/hadoop-3.2.2/sbin/start-yarn.sh

hadoop fs -mkdir /tmp
hadoop fs -mkdir /user
hadoop fs -mkdir /user/hive
hadoop fs -mkdir /user/hive/warehouse
hadoop fs -chmod g+w /tmp
hadoop fs -chmod g+w /user/hive/warehouse
hadoop fs -chmod g+w /


ln -s /usr/share/java/mysql-connector-java.jar /home/hdoop/apache-hive-3.1.2-bin/lib/mysql-connector-java.jar
rm /home/hdoop/apache-hive-3.1.2-bin/lib/guava*
cp /home/hdoop/hadoop-3.2.2/share/hadoop/common/lib/guava* /home/hdoop/apache-hive-3.1.2-bin/lib/

cd /home/hdoop/apache-hive-3.1.2-bin
bin/schematool -dbType mysql -initSchema
nohup bin/hiveserver2  > /dev/null 2>&1 &
bin/beeline  jdbc:hive2://localhost:10000;transportMode=http
echo "End"
