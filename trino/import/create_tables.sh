#!/bin/bash -e

DB=$1
TRINO_SERVER=$2
export TRINO_PASSWORD=$3

SESSION_PARAMS_SNAPPY="hive.compression_codec=SNAPPY"
SESSION_PARAMS_QUERY="query_max_execution_time=10000m"

chmod +x trino/import/occurrence_*.sh
chmod +x trino/import/interp_taxon.sh

log () {
  echo $(tput setaf 6)$(date '+%Y-%m-%d %H:%M:%S ')$(tput setaf 14)$1$(tput sgr0)
}

# Create schema first if it doesn't exist
log "Creating schema $DB"
/data/trino.jar --insecure --debug --server "$TRINO_SERVER" --catalog=hive \
--session=$SESSION_PARAMS_SNAPPY \
--execute="CREATE SCHEMA IF NOT EXISTS $DB with (LOCATION='hdfs://gbif-hdfs/user/hive/warehouse/$DB.db');" \
--user gbif --password

log "Building raw scripts"
./trino/import/build_raw_scripts.sh

log "Executing raw_geo.q"
/data/trino.jar --insecure --debug --server "$TRINO_SERVER" --catalog=hive \
--schema="$DB" --session=$SESSION_PARAMS_SNAPPY --execute="$(<trino/import/raw_geo.q)" --user gbif --password

log "Executing raw_taxon.q"
/data/trino.jar --insecure --debug --server "$TRINO_SERVER" --catalog=hive \
--schema="$DB" --session=$SESSION_PARAMS_SNAPPY --execute="$(<trino/import/raw_taxonomy.q)" --user gbif --password

log "Executing interp_geo.q"
/data/trino.jar --insecure --debug --server "$TRINO_SERVER" --catalog=hive \
--schema="$DB" --session=$SESSION_PARAMS_SNAPPY --execute="$(<trino/import/interp_geo.q)" --user gbif --password

log "Executing interp_taxon.q"

# Use the webservice directly.
# (There's no use to the caching, every query is different. And it's a huge load on Varnish.)
# log 'Finding address of checklistbank-nub-ws'
# zk_servers=sc4n1.gbif.org:30578,sc4n3.gbif.org:30578,uc6n10.gbif.org:30578,uc6n11.gbif.org:30578,uc6n12.gbif.org:30578
# clb_nub_zk_node=$(zookeeper-client -server $zk_servers ls /prod/services/checklistbank-nub-ws 2> /dev/null | grep --only-matching ........-....-....-....-............ | tail -n 1)
# clb_nub_host=$(zookeeper-client -server $zk_servers get /prod/services/checklistbank-nub-ws/$clb_nub_zk_node 2> /dev/null | grep $clb_nub_zk_node | tail -n 1 | jq -r .address)
# clb_nub_port=$(zookeeper-client -server $zk_servers get /prod/services/checklistbank-nub-ws/$clb_nub_zk_node 2> /dev/null | grep $clb_nub_zk_node | tail -n 1 | jq -r .port)
# clb_nub_location=http://$clb_nub_host:$clb_nub_port/
#clb_nub_location=https://api.gbif.org/v1/
nub_location=http://uat2ws2-vh.gbif-uat2.org:8088/
log "Nub address is $nub_location"
clb_location=http://uat2ws1-vh.gbif-uat2.org:9000/
log "CLB address is $clb_location"

interp_taxon_file="trino/import/interp_taxon.q"
./trino/import/interp_taxon.sh $interp_taxon_file $nub_location $clb_location

/data/trino.jar --insecure --debug --server "$TRINO_SERVER" --catalog=hive \
--schema="$DB" --session=$SESSION_PARAMS_SNAPPY --session=$SESSION_PARAMS_QUERY --execute="$(<$interp_taxon_file)" --user gbif --password

log "Creating regions file"
./trino/import/create_regions.sh

# Copy regions to hdfs
$HADOOP_HOME/bin/hdfs dfs -mkdir -p /tmp/regions
$HADOOP_HOME/bin/hdfs dfs -put -f analytics_regions.csv /tmp/regions

log "Executing region_table.q"
/data/trino.jar --insecure --debug --server "$TRINO_SERVER" --catalog=hive \
--schema="$DB" --session=$SESSION_PARAMS_SNAPPY --execute="$(<trino/import/region_table.q)" --user gbif --password

log "Create occurrence tables"
./trino/import/create_occurrence_tables.sh "$DB" "$TRINO_SERVER" "$TRINO_PASSWORD"

