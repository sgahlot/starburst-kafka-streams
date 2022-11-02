
# Setup Kafka instance

## Prerequites
* `rhoas CLI`
* Java 11
* `quarkus CLI`

Get token and login to RHOAS instance (e.g. qaprodauth.console.redhat.com):
* Get token from [https://qaprodauth.console.redhat.com/openshift/token/show](https://qaprodauth.console.redhat.com/openshift/token/show)
* Run `rhoas login --api-gateway https://api.stage.openshift.com -t "<THE TOKEN>`

Note: replace `api.stage.openshift.com` with proper API server URL.

# Creating Kafka instance
Default settings are given in [.env](./.env) file.

Run this to create the Kafka instance, wait until it is ready and then create the topic connect it to a service account:
```bash
./createKafka.sh
```

Run this to check the status:
```
source .env
rhoas status
rhoas kafka describe --name ${KAFKA_NAME}
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
