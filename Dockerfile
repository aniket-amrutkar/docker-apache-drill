FROM java:openjdk-8-jdk

RUN mkdir -p /drill-scripts && \
    mkdir -p /opt/drill && \
    mkdir -p /var/log/drill

ENV DRILL_VERSION 1.11.0
RUN curl -o apache-drill-${DRILL_VERSION}.tar.gz http://www.eu.apache.org/dist/drill/drill-${DRILL_VERSION}/apache-drill-${DRILL_VERSION}.tar.gz && \
    tar -zxpf apache-drill-${DRILL_VERSION}.tar.gz -C /opt/drill
RUN rm apache-drill-${DRILL_VERSION}.tar.gz

#use DRILL_MAX_DIRECT_MEMORY and DRILL_HEAP to control the memory allocation
#also use  DRILL_CLUSTER and ZOOKEEPER

ADD drill-env.sh /opt/drill/apache-drill-${DRILL_VERSION}/conf/drill-env.sh

ENV DRILL_LOG_DIR=/var/log/drill
ENV DRILLBIT_LOG_PATH=/var/log/drill/drillbit.log
ENV DRILLBIT_QUERY_LOG_PATH=/var/log/drill/drill-query.log
ENV DRILL_MAX_DIRECT_MEMORY=8G
ENV DRILL_HEAP=4G  
ENV DRILL_CLUSTER=drillbit1

ENTRYPOINT /opt/drill/apache-drill-${DRILL_VERSION}/bin/drillbit.sh run

EXPOSE 8047
EXPOSE 31010
