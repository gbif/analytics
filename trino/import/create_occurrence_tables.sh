#!/bin/bash
# Builds the occurrence_<date> tables. create_tmp_interp_tables.sh has to be run before this one

DB=$1
TRINO_SERVER=$2
export TRINO_PASSWORD=$3

SESSION_PARAMS_SNAPPY="hive.compression_codec=SNAPPY"

log () {
  echo $(tput setaf 6)$(date '+%Y-%m-%d %H:%M:%S ')$(tput setaf 14)$1$(tput sgr0)
}

declare -a mysql_snapshots=()
declare -a hbase_v1_snapshots=()
declare -a hbase_v2_snapshots=()
declare -a hbase_v3_snapshots=()
declare -a hdfs_v1_snapshots=()

waitForJobsOrFewer () {
    sleep 10
    while [[ $(jobs | wc -l) -ge $1 ]]; do
        echo "Waiting (current "$(jobs | wc -l)", limit $1)"
        sleep 30
    done
}

log 'Creating MySQL snapshots'
for snapshot in "${mysql_snapshots[@]}"
do
    log "Creating MySQL snapshot $snapshot"
    query=$(./trino/import/occurrence_mysql.sh "$snapshot")
    /usr/local/gbif/trino.jar --insecure --debug --server "$TRINO_SERVER" --catalog=hive \
      --schema="$DB" --session=$SESSION_PARAMS_SNAPPY --execute="$query" --user gbif --password
    waitForJobsOrFewer 6
done

log 'Creating HBase V1 snapshots'
for snapshot in "${hbase_v1_snapshots[@]}"
do
    log "Creating HBase V1 snapshot $snapshot"
    query=$(./trino/import/occurrence_v1_hbase.sh "$snapshot")
    /usr/local/gbif/trino.jar --insecure --debug --server "$TRINO_SERVER" --catalog=hive \
      --schema="$DB" --session=$SESSION_PARAMS_SNAPPY --execute="$query" --user gbif --password
    waitForJobsOrFewer 6
done

log 'Creating HBase V2 snapshots'
for snapshot in "${hbase_v2_snapshots[@]}"
do
    log "Creating HBase V2 snapshot $snapshot"
    query=$(./trino/import/occurrence_v2_hbase.sh "$snapshot")
    /usr/local/gbif/trino.jar --insecure --debug --server "$TRINO_SERVER" --catalog=hive \
      --schema="$DB" --session=$SESSION_PARAMS_SNAPPY --execute="$query" --user gbif --password
    waitForJobsOrFewer 6
done

log 'Creating HBase V3 snapshots'
for snapshot in "${hbase_v3_snapshots[@]}"
do
    log "Creating HBase V3 snapshot $snapshot"
    query=$(./trino/import/occurrence_v3_hbase.sh "$snapshot")
    /usr/local/gbif/trino.jar --insecure --debug --server "$TRINO_SERVER" --catalog=hive \
      --schema="$DB" --session=$SESSION_PARAMS_SNAPPY --execute="$query" --user gbif --password
    waitForJobsOrFewer 6
done

log 'Creating HDFS V1 snapshots'
for snapshot in "${hdfs_v1_snapshots[@]}"
do
    log "Creating HDFS V1 snapshot $snapshot"
    query=$(./trino/import/occurrence_v1_hdfs.sh "$snapshot")
    /usr/local/gbif/trino.jar --insecure --debug --server "$TRINO_SERVER" --catalog=hive \
      --schema="$DB" --session=$SESSION_PARAMS_SNAPPY --execute="$query" --user gbif --password
    waitForJobsOrFewer 4
done

echo "Waiting for remaining jobs to finish:"
jobs
wait
