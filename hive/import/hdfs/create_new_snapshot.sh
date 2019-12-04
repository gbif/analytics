#!/bin/bash
if [ "$#" -ne 4 ]; then
    echo "Usage: create_new_snapshot.sh <snapshot Hive DB e.g. snapshot> <snapshot date e.g. 20200101> <source Hive DB e.g. prod_h> <source Hive table e.g. occurrence_pipelines_hdfs>"
    exit 1
fi
hive --hiveconf snapshotdb="$1" --hiveconf snapshot="$2" --hiveconf sourcedb="$3" --hiveconf sourcetable="$4" -f create_hdfs_snapshot.q
