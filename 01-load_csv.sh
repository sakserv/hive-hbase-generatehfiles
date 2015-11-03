#!/bin/bash
SCRIPT_NAME=$(basename $0)
SCRIPT_DIR=`cd $(dirname $0) && pwd`

# Test Data
CSV_SOURCE_FILE=$SCRIPT_DIR/data/passwd_test

# HDFS Locations
HDFS_BASE_DIR=/tmp/hive_hfile_test
CSV_TABLE_DIR=$HDFS_BASE_DIR/passwd_csv

#
# Main
#

# Create the directory and load the data
if hdfs dfs -test -d $HDFS_BASE_DIR; then
  echo -e "\nCleaning up $HDFS_BASE_DIR"
  hdfs dfs -rm -r $HDFS_BASE_DIR || exit 1
fi

# Create the CSV table dir
echo -e "\nCreating HDFS dir $CSV_TABLE_DIR"
hdfs dfs -mkdir -p $CSV_TABLE_DIR || exit 1

# Upload the test data
echo -e "\nCopying $CSV_SOURCE_FILE to HDFS dir $CSV_TABLE_DIR"
hdfs dfs -put $CSV_SOURCE_FILE $CSV_TABLE_DIR || exit 1

# Show the file in HDFS
echo -e "\nListing of $CSV_TABLE_DIR"
hdfs dfs -ls $CSV_TABLE_DIR/


exit 0
