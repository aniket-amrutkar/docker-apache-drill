#!/bin/bash

#Drill cleanup files on restart
rm -rf /tmp/drill/*
rm -rf /var/log/drill/*

#Drill home dir
DRILL_HOME=/opt/drill/apache-drill-${DRILL_VERSION}

#Drill classpath
CP=$DRILL_HOME/conf:$DRILL_HOME/jars/*:$DRILL_HOME/jars/ext/*:$DRILL_HOME/jars/3rdparty/*:$DRILL_HOME/jars/classb/*

#Drill memory config
DRILL_MAX_DIRECT_MEMORY=${DRILL_MAX_DIRECT_MEMORY:-"8G"}
DRILL_HEAP=${DRILL_HEAP:-"4G"}
DRILLBIT_MAX_PERM=${DRILLBIT_MAX_PERM:-"512M"}
DRILLBIT_CODE_CACHE_SIZE=${DRILLBIT_CODE_CACHE_SIZE:-"1G"}
DRILL_EXEC_BUFFER_SIZE=${DRILL_EXEC_BUFFER_SIZE:-"3"}
DRILL_PROFILES_STORE_INMEMORY=${DRILL_PROFILES_STORE_INMEMORY:-"true"}
DRILL_PROFILES_STORE_CAPACITY=${DRILL_PROFILES_STORE_CAPACITY:-"1000"}

#Drill cluster name
DRILL_CLUSTER=${DRILL_CLUSTER:-"falkonry"}

#Zookeeper url
ZOOKEEPER=${ZOOKEEPER:-"localhost:2181"}

#Others
DRILL_RPC_USER_TIMEOUT=${DRILL_RPC_USER_TIMEOUT:-"3600"}

HDFS=$(printf '%s\n' "$HDFS_URL" | sed 's:[][\/.^$*]:\\&:g')
PATH_PREFIX=$(printf '%s\n' "$HDFS_DATA_PREFIX" | sed 's:[\/&]:\\&:g;$!s/$/\\/')

echo "drill.exec:{ cluster-id: \"$DRILL_CLUSTER\", zk.connect: \"$ZOOKEEPER\", buffer.size : \"$DRILL_EXEC_BUFFER_SIZE\", rpc.user.timeout: $DRILL_RPC_USER_TIMEOUT , profiles.store.inmemory: $DRILL_PROFILES_STORE_INMEMORY , profiles.store.capacity: \"$DRILL_PROFILES_STORE_CAPACITY\" }" > $DRILL_HOME/conf/drill-override.conf

sed -i -e "s/HDFS/$HDFS/" $DRILL_HOME/conf/bootstrap-storage-plugins.json
sed -i -e "s/PREFIX/$PATH_PREFIX/" $DRILL_HOME/conf/bootstrap-storage-plugins.json
sed -i -e "s/HDFS/$HDFS/" /dfs.config
sed -i -e "s/PREFIX/$PATH_PREFIX/" /dfs.config

#updating storage and sys config
${DRILL_HOME}/bin/update.sh &

java -Xms$DRILL_HEAP -Xmx$DRILL_HEAP -XX:MaxDirectMemorySize=$DRILL_MAX_DIRECT_MEMORY \
	-XX:ReservedCodeCacheSize=$DRILLBIT_CODE_CACHE_SIZE -Ddrill.exec.enable-epoll=false \
	-XX:MaxPermSize=$DRILLBIT_MAX_PERM -XX:+CMSClassUnloadingEnabled -XX:+UseG1GC \
	-cp $CP \
	org.apache.drill.exec.server.Drillbit