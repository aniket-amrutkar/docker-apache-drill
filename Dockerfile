FROM java:openjdk-8-jdk

RUN mkdir -p /opt/drill

RUN apt-get update

ENV DRILL_VERSION 1.11.0
RUN curl -o apache-drill-${DRILL_VERSION}.tar.gz http://www.eu.apache.org/dist/drill/drill-${DRILL_VERSION}/apache-drill-${DRILL_VERSION}.tar.gz && \
    tar -zxpf apache-drill-${DRILL_VERSION}.tar.gz -C /opt/drill
RUN rm apache-drill-${DRILL_VERSION}.tar.gz

#use DRILL_MAX_DIRECT_MEMORY and DRILL_HEAP to control the memory allocation
#also use  DRILL_CLUSTER and ZOOKEEPER

ENV DRILL_MAX_DIRECT_MEMORY=8G
ENV DRILL_HEAP=4G  
ENV DRILL_CLUSTER=falkonry
ADD dfs.config /dfs.config
ADD bootstrap-storage-plugins.json /opt/drill/apache-drill-${DRILL_VERSION}/conf
ADD start.sh /opt/drill/apache-drill-${DRILL_VERSION}/bin
ADD update.sh /opt/drill/apache-drill-${DRILL_VERSION}/bin
ADD logback.xml /opt/drill/apache-drill-${DRILL_VERSION}/conf

ENTRYPOINT /opt/drill/apache-drill-${DRILL_VERSION}/bin/start.sh

EXPOSE 8047
EXPOSE 31010
