#!/bin/bash
source .env

CLIENT_ID=$(grep clientID ./sa-credentials.json | cut -d ":" -f2 | tr -d '", ')
rhoas kafka delete --name ${KAFKA_NAME} -y
rhoas service-account delete --id ${CLIENT_ID} -y

