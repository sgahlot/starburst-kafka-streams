#!/bin/bash

source .env

${KSQL_HOME}/bin/ksql http://localhost:8088

