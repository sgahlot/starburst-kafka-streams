#!/bin/bash
source .env

KSQLCLIENT_ID=$(grep clientID ./ksqlsa-credentials.json | cut -d ":" -f2 | tr -d '", ')
rhoas service-account delete --id ${KSQLCLIENT_ID} -y

rhoas kafka acl delete --service-account ${KSQLCLIENT_ID} --cluster -y
rhoas kafka acl delete --service-account ${KSQLCLIENT_ID} --topic "_confluent-ksql-${KSQL_SERVICEID}" --prefix -y
rhoas kafka acl delete --service-account ${KSQLCLIENT_ID} --group "_confluent-ksql-${KSQL_SERVICEID}" --prefix -y
rhoas kafka acl delete --service-account ${KSQLCLIENT_ID} --group "${KSQLKAFKA_CONSUMER_GROUP}" --prefix -y
rhoas kafka acl delete --service-account ${KSQLCLIENT_ID} --topic "${KSQL_SERVICEID}" --prefix -y
rhoas kafka acl delete --service-account ${KSQLCLIENT_ID} --topic "*" -y
rhoas kafka acl delete --service-account ${KSQLCLIENT_ID} --transactional-id ${KSQL_SERVICEID} --prefix -y
