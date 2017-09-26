DRILL_MAX_DIRECT_MEMORY=${DRILL_MAX_DIRECT_MEMORY:="8G"}
DRILL_HEAP=${DRILL_HEAP:="4G"}
DRILL_EXEC_BUFFER_SIZE=${DRILL_EXEC_BUFFER_SIZE:="3"}

echo DRILL_MAX_DIRECT_MEMORY set to $DRILL_MAX_DIRECT_MEMORY
echo DRILL_HEAP set to $DRILL_HEAP
echo DRILL_CLUSTER set to $DRILL_CLUSTER
echo ZOOKEEPER set to $ZOOKEEPER
echo DRILL_EXEC_BUFFER_SIZE set to $DRILL_EXEC_BUFFER_SIZE

export DRILL_JAVA_OPTS="-Xms$DRILL_HEAP -Xmx$DRILL_HEAP -XX:MaxDirectMemorySize=$DRILL_MAX_DIRECT_MEMORY -XX:ReservedCodeCacheSize=1G -Ddrill.exec.enable-epoll=true"

# Class unloading is disabled by default in Java 7
# http://hg.openjdk.java.net/jdk7u/jdk7u60/hotspot/file/tip/src/share/vm/runtime/globals.hpp#l1622
export SERVER_GC_OPTS="-XX:+CMSClassUnloadingEnabled -XX:+UseG1GC "


echo "drill.exec:{ cluster-id: \"$DRILL_CLUSTER\", zk.connect: \"$ZOOKEEPER\", buffer.size : \"$DRILL_EXEC_BUFFER_SIZE\", rpc.user.timeout: 3600 }" > /opt/drill/apache-drill-${DRILL_VERSION}/conf/drill-override.conf

