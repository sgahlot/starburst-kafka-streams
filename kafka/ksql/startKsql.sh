#!/bin/bash

source .env

cp $KSQL_HOME/config/ksql-server.properties ksql-server.properties.orig
sed '/bootstrap.servers.*/d' ./ksql-server.properties.orig > ./ksql-server.properties

KSQLCLIENT_ID=$(grep clientID ./ksqlsa-credentials.json | cut -d ":" -f2 | tr -d '", ')
KSQLSECRET=$(grep clientSecret ./ksqlsa-credentials.json | cut -d ":" -f2 | tr -d '", ')

echo "Starting ksql-server with"
echo "$KAFKA_HOST"
echo "$KSQLCLIENT_ID"
echo "$KSQLSECRET"

echo "
bootstrap.servers=https://${KAFKA_HOST}:443
group.id=${KSQLKAFKA_CONSUMER_GROUP}
security.protocol=SASL_SSL
sasl.mechanism=PLAIN
sasl.jaas.config=\\
    org.apache.kafka.common.security.plain.PlainLoginModule required \\
    username=\"${KSQLCLIENT_ID}\" \\
    password=\"${KSQLSECRET}\" ;
ksql.service.id=${KSQL_SERVICEID}
ksql.output.topic.name.prefix=${KSQL_TOPIC_PREFIX}" >> ./ksql-server.properties

export KSQL_LOG4J_OPTS="-Dlog4j.configuration=file:${KSQL_HOME}/config/log4j.properties"
${KSQL_HOME}/bin/ksql-server-start ./ksql-server.properties
