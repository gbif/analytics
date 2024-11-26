#!/bin/bash
# Builds the occurrence_<date> tables. create_tmp_interp_tables.sh has to be run before this one

DB=$1
TRINO_SERVER=$2
export TRINO_PASSWORD=$3

SESSION_PARAMS_SNAPPY="hive.compression_codec=SNAPPY"

log () {
  echo $(tput setaf 6)$(date '+%Y-%m-%d %H:%M:%S ')$(tput setaf 14)$1$(tput sgr0)
}

declare -a mysql_snapshots=("20071219" "20080401" "20080627" "20081010" "20081217" "20090406" "20090617" "20090925" "20091216" "20100401" "20100726" "20101117" "20110221" "20110610" "20110905" "20120118" "20120326" "20120713" "20121031" "20121211" "20130220" "20130521" "20130709" "20130910")
declare -a hbase_v1_snapshots=("20131220" "20140328")
declare -a hbase_v2_snapshots=("20140908" "20150119" "20150409")
declare -a hbase_v3_snapshots=("20150703" "20151001" "20160104" "20160405" "20160704" "20161007" "20161227" "20170412" "20170724" "20171012" "20171222" "20180409" "20180711" "20180928" "20190101" "20190406" "20190701" "20191009")
declare -a hdfs_v1_snapshots=("20200101" "20200401" "20200701" "20201001" "20210101" "20210401" "20210701" "20211001" "20220101" "20220401" "20220701" "20221001" "20230101" "20230401" "20230701" "20231001" "20240101" "20240401" "20240701" "20241001")

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
