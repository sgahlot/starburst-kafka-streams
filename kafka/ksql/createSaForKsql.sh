#!/bin/bash

source ../.env
source .env

rhoas service-account create --output-file=./ksqlsa-credentials.json --file-format json --overwrite --short-description=${KSQLSA_NAME}

KSQLCLIENT_ID=$(grep clientID ./ksqlsa-credentials.json | cut -d ":" -f2 | tr -d '", ')

# The DESCRIBE_CONFIGS operation on the CLUSTER resource type.
rhoas kafka acl create --operation describe --service-account ${KSQLCLIENT_ID} --cluster --permission allow -y

# The ALL operation on all internal TOPICS that are PREFIXED with _confluent-ksql-<ksql.service.id>.
# Where ksql.service.id can be configured in the ksqlDB configuration and defaults to default_.
#rhoas kafka acl create --operation all --service-account ${KSQLCLIENT_ID} --topic "_confluent-ksql-${KSQL_SERVICEID}" --prefix --permission allow -y

# The ALL operation on all internal GROUPS that are PREFIXED with _confluent-ksql-<ksql.service.id>.
rhoas kafka acl create --operation all --service-account ${KSQLCLIENT_ID} --group "_confluent-ksql-${KSQL_SERVICEID}" --prefix --permission allow -y

# The ALL operation on the TOPIC with LITERAL name <ksql.logging.processing.topic.name>.
# Where ksql.logging.processing.topic.name can be configured in the ksqlDB configuration and defaults to <ksql.service.id>ksql_processing_log.
#rhoas kafka acl create --operation all --service-account ${KSQLCLIENT_ID} --topic "${KSQL_SERVICEID}" --prefix --permission allow -y

# Often output topics from one query form the inputs to others. ksqlDB will require READ and WRITE permissions for such topics.
#rhoas kafka acl create --operation all --service-account ${KSQLCLIENT_ID} --topic "${KAFKA_TOPIC}" --permission allow -y

rhoas kafka acl create --operation all --service-account ${KSQLCLIENT_ID} --transactional-id ${KSQL_SERVICEID} --prefix --permission allow -y
rhoas kafka acl create --operation all --service-account ${KSQLCLIENT_ID} --group "${KSQLKAFKA_CONSUMER_GROUP}" --prefix --permission allow -y
rhoas kafka acl create --operation all --service-account ${KSQLCLIENT_ID} --topic "*" --permission allow -y
