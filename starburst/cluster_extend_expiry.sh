#!/bin/sh

# Extends expiry for the given cluster by first retrieving its ID and then using that ID to set the new expiration_timestamp
function extend_expiry() {
    local cluster_name=$1
    #ocm describe cluster $1 --json
    local cluster_id=`ocm describe cluster $1 --json | jq -r .id`
    printf "Extending expiry for cluster [name=$cluster_name, id=$cluster_id]\n"
    printf '{"expiration_timestamp": "%s"}' "$(date -v+7d +"%Y-%m-%dT00:00:00Z")" | ocm patch /api/clusters_mgmt/v1/clusters/$cluster_id > /tmp/ocm_extend_exipry.out
    printf 'Cluster expiry set to %s\n' `ocm describe cluster $1 --json | jq -r .expiration_timestamp`
}



if [ -z $1 ]; then
    printf "Usage: $0 <CLUSTER_NAME>\n"
    printf "\n Please make sure you've already logged in using the following command\n before running this script\n -> 'ocm login --url=https://api.stage.openshift.com/ --token=<TOKEN>'\n"
else
    extend_expiry "$1"
fi

