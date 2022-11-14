#!/bin/bash
source .env

CLIENT_ID=$(grep clientID ./sa-credentials.json | cut -d ":" -f2 | tr -d '", ')
# Alternately, one can use following command to extract the clientID
# CLIENT_ID=`cat sa-credentials.json | jq -r .clientID`

rhoas kafka delete --name ${KAFKA_NAME} -y
rhoas service-account delete --id ${CLIENT_ID} -y

