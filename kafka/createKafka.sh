#!/bin/bash

source .env

rhoas kafka create --name ${KAFKA_NAME} --wait
rhoas context set-kafka --name ${KAFKA_NAME}
rhoas generate-config --type json --overwrite --output-file ${KAFKA_TOPIC_CONFIG_JSON}

rhoas kafka topic create --name ${KAFKA_TOPIC}

rhoas service-account create --output-file=./${SA_CRED_JSON} --file-format json --overwrite --short-description=${SA_NAME}
CLIENT_ID=$(grep clientID ./${SA_CRED_JSON} | cut -d ":" -f2 | tr -d '", ')
# Alternately, one can use following command to extract the clientID
# CLIENT_ID=`cat sa-credentials.json | jq -r .clientID`

rhoas kafka acl grant-access --consumer --producer \
    --service-account ${CLIENT_ID} --topic-prefix ${KAFKA_TOPIC}  --group ${KAFKA_CONSUMER_GROUP} -y