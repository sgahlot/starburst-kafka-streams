#!/bin/bash

source .env

rhoas kafka create --name ${KAFKA_NAME} --wait
rhoas context set-kafka --name ${KAFKA_NAME}
rhoas generate-config --type json --overwrite --output-file ${KAFKA_TOPIC}.json

rhoas kafka topic create --name ${KAFKA_TOPIC}

rhoas service-account create --output-file=./sa-credentials.json --file-format json --overwrite --short-description=${SA_NAME}
CLIENT_ID=$(grep clientID ./sa-credentials.json | cut -d ":" -f2 | tr -d '", ')
rhoas kafka acl grant-access --consumer --producer \
    --service-account ${CLIENT_ID} --topic-prefix ${KAFKA_TOPIC}  --group ${KAFKA_CONSUMER_GROUP} -y
