# Installing, configuring and running ksql server and CLI 
>
> For the purposes of this topic, "ksqlDB" refers to ksqlDB 0.6.0 and beyond, and "KSQL" refers to all previous releases of KSQL (5.3 and lower).
>

[What is KSQL?: Data Streaming Using Apache Kafka](https://hevodata.com/learn/ksql/)

## Local installation
Prerequisites:
* Java > 8
* Maven 3.x
* `rhoas CLI`
* Kafka instance exists in RHOAS service (using [creating-kafka-instance](../README.md#creating-kafka-instance) procedure)

In order to run the following procedures, we need to clone the [ksqlDB](https://github.com/confluentinc/ksql) repository.
Please checkout a stable branch like `v7.2.2`, otherwise it would not find the required dependencies.

Build the application in the local repository:
```bash
cd <PATH TO ksqlDB LOCAL REPOSITORY>
mvn clean install
```

## Edit .env file
The `KSQL_HOME` property in [.env](./.env) file defines the location of the local `ksql` repository, and must be updated
with the expected value. Other properties can remain untouched:
```properties
KSQL_HOME=../../../ksql
...
```

## Create service account and ACLs
A new service account is created to connect the `ksql-server` as a client of the Kafka instance. Please refer to the 
following link for details on the required ACL configuration: 
[Required ACLs](https://github.com/confluentinc/ksql/blob/master/docs/operate-and-deploy/installation/server-config/security.md#required-acls)

Create the service account and define all the needed ACL entries:
```bash
./createSaForKsql.sh
```

**Note**: for the purpose of this exercise, we allowed the new service account full permissions on all the topics, because 
new topics might be created automatically when executing the SQL commands, see [list-of-topics](#list-of-topics). 

## Start ksql server
Launch the `ksql-server` with the configuration file created as `ksql-server.properties` from the default configuration
in `$KSQL_HOME/config`:
```bash
 ./startKsql.sh
 ```

## Launch ksql-cli
Connect `ksql-cli` to the server listening at `http://localhost:8088`:
```bash
 ./startKsqlCli.sh
 ```

### Running queries
[ksqlDB Synopsis](https://docs.ksqldb.io/en/latest/concepts/)
#### Topics
Show topics and print content (`CTRL-C` to interrupt):
```sql
SHOW TOPICS;
PRINT 'persons';
```
#### Streams
>
> A stream is a partitioned, immutable, append-only collection that represents a series of historical facts
> 

Create a new stream and run a SELECT:
```sql
CREATE STREAM persons_stream (name varchar, genre varchar, age int) WITH
(kafka_topic='persons', value_format='JSON');
SHOW STREAMS;
SELECT name from persons_stream LIMIT 3;
```
Another stream using the initial one:
```sql
CREATE STREAM persons_age_range_stream AS
SELECT UCASE(name) AS capitalized_name, genre, age, ROUND(age/10) * 10 as age_range 
FROM persons_stream;

SELECT capitalized_name from persons_age_range_stream LIMIT 4;
SELECT capitalized_name from persons_age_range_stream EMIT CHANGES;
select age, age_range from persons_age_range_stream emit changes;
select count(*) as persons_by_age_range, age_range from persons_age_range_stream group by age_range emit changes;
```

#### Tables
>
> A table is a mutable, partitioned collection that models change over time
> 

[CREATE TABLE](https://docs.ksqldb.io/en/latest/developer-guide/ksqldb-reference/create-table/)
>
> If a table is created directly on top of a Kafka topic, it's not materialized.
> Non-materialized tables can't be queried, because they would be highly inefficient.
>
Expect error from the following `SELECT` statement:
```bash
CREATE TABLE persons_table (
      name VARCHAR PRIMARY KEY, 
      genre VARCHAR, 
      age INT
  ) WITH (
    KAFKA_TOPIC='persons', 
    VALUE_FORMAT='JSON'
  );

SELECT name from persons_table;
```

Correct using a materialized view:
```sql
CREATE TABLE QUERYABLE_PERSONS_TABLE AS
    SELECT * FROM PERSONS_TABLE;
SELECT name from QUERYABLE_PERSONS_TABLE;
SELECT count(*) as persons_by_genre, genre from QUERYABLE_PERSONS_TABLE GROUP BY genre  EMIT CHANGES;
```
**TODO**: empty queries

### List of topics
List of topics at the begin of the exercise (after the `ksql-server` started):
```bash
> rhoas kafka topic list
  NAME                                          PARTITIONS   RETENTION TIME (MS)   RETENTION SIZE (BYTES)  
 --------------------------------------------- ------------ --------------------- ------------------------ 
  _confluent-ksql-ksql-service-_command_topic            1   -1 (Unlimited)        -1 (Unlimited)          
  ksql-service-ksql_processing_log                       1   604800000             -1 (Unlimited)          
  persons                                                1   604800000             -1 (Unlimited) 
```

Notice the list of topics at the end of the exercise:
```bash
> rhoas kafka topic list
  NAME (9)                                                                                                                                               PARTITIONS   RETENTION TIME (MS)   RETENTION SIZE (BYTES)  
 ------------------------------------------------------------------------------------------------------------------------------------------------------ ------------ --------------------- ------------------------ 
  _confluent-ksql-ksql-service-_command_topic                                                                                                                     1   -1 (Unlimited)        -1 (Unlimited)          
  _confluent-ksql-ksql-service-query_CTAS_QUERYABLE_PERSONS_TABLE_19-KsqlTopic-Reduce-changelog                                                                   1   604800000             -1 (Unlimited)          
  _confluent-ksql-ksql-service-transient_transient_QUERYABLE_PERSONS_TABLE_4817192022386807105_1667578355474-Aggregate-Aggregate-Materialize-changelog            1   604800000             -1 (Unlimited)          
  _confluent-ksql-ksql-service-transient_transient_QUERYABLE_PERSONS_TABLE_4817192022386807105_1667578355474-Aggregate-GroupBy-repartition                        1   -1 (Unlimited)        -1 (Unlimited)          
  _confluent-ksql-ksql-service-transient_transient_QUERYABLE_PERSONS_TABLE_4817192022386807105_1667578355474-KsqlTopic-Reduce-changelog                           1   604800000             -1 (Unlimited)          
  ksql-topic-PERSONS_AGE_RANGE_STREAM                                                                                                                                   1   604800000             -1 (Unlimited)          
  ksql-topic-QUERYABLE_PERSONS_TABLE                                                                                                                                    1   604800000             -1 (Unlimited)          
  ksql-service-ksql_processing_log                                                                                                                                1   604800000             -1 (Unlimited)          
  persons                                                                                                                                                         1   604800000             -1 (Unlimited)          
```

#### Other useful commands
```sql
DESCRIBE <TABLE/STREAM> [EXTENDED];

DROP STREAM <STREAM>;
DROP TABLE <TABLE>;

SHOW STREAMS;
SHOW TABLES;
```

### Cleanup
Run the following to remove the service account and ACL settings:
```bash
./deleteAll.sh
```
