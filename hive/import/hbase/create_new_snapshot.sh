#!/bin/bash
if [ "$#" -ne 4 ]; then
    echo "Usage: create_new_snapshot.sh <snapshot hive db e.g. snapshot> <snapshot date e.g. 20140923> <source hive db e.g. prod_b> <source hive table e.g. occurrence_hbase>"
    exit 1
fi
# ensure HIVE_HOME is set
: ${HIVE_HOME:?"Need to set HIVE_HOME env variable to point to Hive's root dir"}
hhpattern="hive-hbase-handler*jar"
hivehbase=`find "$HIVE_HOME/lib/" -name "$hhpattern"`
hbasepattern="hbase-*jar"
hbase=`find "$HIVE_HOME/lib/" -name "$hbasepattern"`
hive --hiveconf snapshotdb="$1" --hiveconf snapshot="$2" --hiveconf sourcedb="$3" --hiveconf sourcetable="$4" --hiveconf hivehbase="$hivehbase" --hiveconf hbase="$hbase" -f create_hbase_snapshot.q
