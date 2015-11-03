Hive HBase Generate HFiles
--------------------------

This project contains an example of leveraging the Hive HBaseStorageHandler for HFile generation. This pattern provides a means of taking data already stored in Hive, exporting it as HFiles, and bulk loading the HBase table from those HFiles.

Overview
--------
The HFile generation feature was added in [HIVE-6473](https://issues.apache.org/jira/browse/HIVE-6473).

It adds the following properties that are then leveraged by the Hive HBaseStorageHandler.
* hive.hbase.generatehfiles - true to generate HFiles
* hfile.family.path - path in HDFS to put the HFiles.

Note that for hfile.family.path, the final sudirectory MUST MATCH the column family name.

The scripts in the project can be used with the Hortonworks Sandbox to test and demo this feature.

Example 
--------
The following is an example of how to use this feature. The scripts in this repo implement the steps below.

It is assumed that the user already has data stored in a hive table, for the sake of this example, the following table was used.

```
CREATE EXTERNAL TABLE passwd_orc(userid STRING, uid INT, shell STRING)
STORED AS ORC
LOCATION '/tmp/passwd_orc';
```

First, decide on the HBase table and column family name. We want to use a single column family. For the example below, the HBase table name is "passwd_hbase", the column family name is "passwd".

Below is the DDL for the HBase table created through Hive. Couple of notes:
* userid as my row key.
* :key is special syntax in the hbase.columns.mapping
* each column (qualifier) is in the form column family:column (qualifier)

```
CREATE TABLE passwd_hbase(userid STRING, uid INT, shell STRING)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key,passwd:uid,passwd:shell');
```

Next, generate the HFiles for the table. Couple of notes again:
* The hfile.family.path is where the hfiles will be generated.
* The final subdirectory name MUST match the column family name.

```
SET hive.hbase.generatehfiles=true;
SET hfile.family.path=/tmp/passwd_hfiles/passwd;
INSERT OVERWRITE TABLE passwd_hbase SELECT DISTINCT userid,uid,shell FROM passwd_orc CLUSTER BY userid;
```

Finally, load the HFiles into the HBase table:

```
export HADOOP_CLASSPATH=`hbase classpath`
yarn jar /usr/hdp/current/hbase-client/lib/hbase-server.jar completebulkload /tmp/passwd_hfiles passwd_hbase
```

