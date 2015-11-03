SET hive.execution.engine=mr;
SET hive.hbase.generatehfiles=true;
SET hfile.family.path=/tmp/hive_hfile_test/passwd_hbase_hfiles/passwd;

INSERT OVERWRITE TABLE passwd_hbase SELECT DISTINCT userid,uid,shell FROM passwd_orc CLUSTER BY userid;
