#!/bin/bash
source .env

KAFKA_HOST=$(grep kafkaHost ./persons.json | cut -d ":" -f2 | tr -d '", ')
RHOAS_SERVICE_ACCOUNT_CLIENT_ID=$(grep clientID ./sa-credentials.json | cut -d ":" -f2 | tr -d '", ')
RHOAS_SERVICE_ACCOUNT_CLIENT_SECRET=$(grep clientSecret ./sa-credentials.json | cut -d ":" -f2 | tr -d '", ')
RHOAS_SERVICE_ACCOUNT_OAUTH_TOKEN_URL=https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token

echo "Starting Quarkus loader with"
echo "$KAFKA_HOST"
echo "$RHOAS_SERVICE_ACCOUNT_CLIENT_ID"
echo "$RHOAS_SERVICE_ACCOUNT_CLIENT_SECRET"
quarkus dev

