
# Extend OpenShift cluster expiration

The cluster by default is ONLY available for 1 day. The script mentioned in this
readme will extend the cluster expiration to 1 week

## Prerequisites
* `ocm CLI`

## Login
Get token and login using ocm (OpenShift Cluster Manager):
* One can get token from one of the following:
    * Staging: [qaprodauth.console.redhat.com](https://qaprodauth.console.redhat.com/openshift/token/show)
    * Prod: [console.redhat.com](https://console.redhat.com/openshift/token/show)
* Run the following command:
```
ocm login --url https://api.stage.openshift.com/ --token <TOKEN>
```
**Note**: 
_If a different API server is used, please change the above url to point to the correct API server_
* Staging: `api.stage.openshift.com`
* Prod: `api.openshift.com`

# Execute extension script
Execute the cluster expiry extention script by running the following command:
```
./cluster_extend_expiry.sh
```
