FROM quay.io/falkonry/openjdk:8-jdk-alpine

ENV DRILL_VERSION 1.12.0 && \
	DRILL_MAX_DIRECT_MEMORY 8G && \
	ENV DRILL_HEAP 4G && \
	ENV DRILL_CLUSTER falkonry

RUN mkdir -p /opt/drill && \
	curl -o apache-drill-${DRILL_VERSION}.tar.gz http://www.eu.apache.org/dist/drill/drill-${DRILL_VERSION}/apache-drill-${DRILL_VERSION}.tar.gz && \
    tar -zxpf apache-drill-${DRILL_VERSION}.tar.gz -C /opt/drill && \
    rm apache-drill-${DRILL_VERSION}.tar.gz

ADD dfs.config /dfs.config && \
	bootstrap-storage-plugins.json /opt/drill/apache-drill-${DRILL_VERSION}/conf && \
	start.sh /opt/drill/apache-drill-${DRILL_VERSION}/bin && \
	update.sh /opt/drill/apache-drill-${DRILL_VERSION}/bin && \
	logback.xml /opt/drill/apache-drill-${DRILL_VERSION}/conf

ENTRYPOINT /opt/drill/apache-drill-${DRILL_VERSION}/bin/start.sh

EXPOSE 8047 31010