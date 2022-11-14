
# Setup Kafka instance

## Prerequites
* `rhoas CLI`
* Java 11
* `quarkus CLI`

Get token and login to RHOAS instance (e.g. qaprodauth.console.redhat.com):
* One can get token from one of the following:
  * Staging: [qaprodauth.console.redhat.com](https://qaprodauth.console.redhat.com/openshift/token/show)
  * Prod: [console.redhat.com](https://console.redhat.com/openshift/token/show)
* Run `rhoas login --api-gateway https://api.stage.openshift.com -t "<THE TOKEN>`

Note: replace `api.stage.openshift.com` with proper API server URL. _For Prod, use `api.openshift.com`_

# Creating Kafka instance
Default settings are given in [.env](./.env) file.

Run this to create the Kafka instance, wait until it is ready and then create the topic connect it to a service account:
```bash
./createKafka.sh
```

Run this to check the status:
```
./checkKafkaStatus.sh
```

# Populating Kafka with instances
Run the Quarkus application to connect to the cluster and create one instance of random `Person` with this attributes every 5":
```bash
Person [name=Michele_Tessa, genre=F, age=62]
```

```bash
./startLoader.sh 
```

## Delete the Kafka resources
Unprovision the Kafka instance and the service account:
```bash
deleteAll.sh
```