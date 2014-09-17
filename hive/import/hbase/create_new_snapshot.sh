#!/bin/bash
if [ "$#" -ne 4 ]; then
    echo "Usage: create_new_snapshot.sh <snapshot hive db e.g. snapshot> <snapshot date e.g. 20140923> <source hive db e.g. prod_b> <source hive table e.g. occurrence_hbase>"
    exit 1
fi
hive --hiveconf snapshotdb="$1" --hiveconf snapshot="$2" --hiveconf sourcedb="$3" --hiveconf sourcetable="$4" -f create_hbase_snapshot.q