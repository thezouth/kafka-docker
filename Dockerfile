FROM maven:3.5.3-jdk-8 as builder
RUN git clone https://github.com/webscal3r/kafka-graphite.git
WORKDIR /kafka-graphite
RUN git checkout 1.0.4 \
    &&mvn package

FROM wurstmeister/kafka:1.0.1
COPY --from=builder /kafka-graphite/target/kafka-graphite-1.0.4.jar /opt/kafka/libs/kafka-graphite.jar
RUN mkdir -p /tmp/scripts
COPY scripts /tmp/scripts
RUN cd /opt/kafka/bin && \
  sh /tmp/scripts/update-source.sh && \
  chmod +x kafka-consumer-lag.sh

