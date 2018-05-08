#!/bin/bash

HOST=`hostname -s`
DOMAIN=`hostname -d`

if [[ $HOST =~ (.*)-([0-9]+)$ ]]; then
	NAME=${BASH_REMATCH[1]}
	ORD=${BASH_REMATCH[2]}
else
	echo "Fialed to parse name and ordinal of Pod"
	exit 1
fi

export KAFKA_BROKER_ID=$((ORD+1))
export KAFKA_ADVERTISED_HOST_NAME=$(hostname -f)
export KAFKA_ZOOKEEPER_CONNECT="$(nslookup ${ZOOKEEPER_SERVICE}.default.svc.cluster.local | grep -e '\.'${ZOOKEEPER_SERVICE} | awk '{print $4}' | awk 1 ORS=':2181,' | sed 's/,$//')/${ZOOKEEPER_PATH}"
start-kafka.sh

