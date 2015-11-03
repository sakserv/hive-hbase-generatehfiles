#!/bin/bash
SCRIPT_NAME=$(basename $0)
SCRIPT_DIR=`cd $(dirname $0) && pwd`

HBASE_TABLE_NAME=passwd_hbase
HFILE_HDFS_INPUT_DIR=/tmp/hive_hfile_test/passwd_hbase_hfiles

#
# Main
#

# Create the hive table
echo -e "\nRunning the hbase bulk load for $HBASE_TABLE_NAME using input at $HFILE_HDFS_INPUT_DIR"
export HADOOP_CLASSPATH=`hbase classpath`
yarn jar /usr/hdp/current/hbase-client/lib/hbase-server.jar completebulkload $HFILE_HDFS_INPUT_DIR $HBASE_TABLE_NAME

# Run a select to validate
echo -e "\nRunning select on table $HIVE_TABLE_NAME"
hive -S -e "select * from $HIVE_TABLE_NAME limit 10;" 2>/dev/null
