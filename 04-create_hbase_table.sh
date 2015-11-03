#!/bin/bash
SCRIPT_NAME=$(basename $0)
SCRIPT_DIR=`cd $(dirname $0) && pwd`

HIVE_SCRIPT=$SCRIPT_DIR/hive/passwd_hbase.hsql
HIVE_TABLE_NAME=passwd_hbase

#
# Main
#

# Create the hive table
echo -e "\nRunning hive script $HIVE_SCRIPT"
hive -S -f $HIVE_SCRIPT 2>/dev/null

# Run a select to validate
echo -e "\nRunning select on table $HIVE_TABLE_NAME"
hive -S -e "select * from $HIVE_TABLE_NAME limit 10;" 2>/dev/null

exit 0
