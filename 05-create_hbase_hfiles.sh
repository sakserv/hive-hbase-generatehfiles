#!/bin/bash
SCRIPT_NAME=$(basename $0)
SCRIPT_DIR=`cd $(dirname $0) && pwd`

HIVE_SCRIPT=$SCRIPT_DIR/hive/passwd_create_hbase_hfiles.sql
HFILE_HDFS_OUTPUT_DIR=/tmp/hive_hfile_test/passwd_hbase_hfiles/passwd

#
# Main
#

# Create the hive table
echo -e "\nRunning hive script $HIVE_SCRIPT"
hive -f $HIVE_SCRIPT 

# Validate the HFile directory contains data
echo -e "\nValidating data exists in the hfile output directory: $HFILE_HDFS_OUTPUT_DIR"
hdfs dfs -ls $HFILE_HDFS_OUTPUT_DIR

exit 0
