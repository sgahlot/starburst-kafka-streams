#!/bin/sh

source .env
rhoas status
rhoas kafka describe --name ${KAFKA_NAME}
