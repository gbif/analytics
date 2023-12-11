#!/bin/bash -e

DB=$1
TRINO_SERVER=$2
export TRINO_PASSWORD=$3
KUBE_CONFIG=$4

SESSION_PARAMS_SNAPPY="hive.compression_codec=SNAPPY"

log () {
  echo $(tput setaf 6)$(date '+%Y-%m-%d %H:%M:%S ')$(tput setaf 14)$1$(tput sgr0)
}

# Create schema first if it doesn't exist
log "Creating schema $DB"
/usr/local/gbif/trino.jar --insecure --debug --server "$TRINO_SERVER" --catalog=hive \
--session=$SESSION_PARAMS_SNAPPY \
--execute="CREATE SCHEMA IF NOT EXISTS $DB with (LOCATION='hdfs://gbif-hdfs/stackable/warehouse/$DB.db');" \
--user gbif --password

log "Building raw scripts"
./trino/import/build_raw_scripts.sh

log "Executing raw_geo.q"
/usr/local/gbif/trino.jar --insecure --debug --server "$TRINO_SERVER" --catalog=hive \
--schema="$DB" --session=$SESSION_PARAMS_SNAPPY --execute="$(<trino/import/raw_geo.q)" --user gbif --password

log "Executing raw_taxon.q"
/usr/local/gbif/trino.jar --insecure --debug --server "$TRINO_SERVER" --catalog=hive \
--schema="$DB" --session=$SESSION_PARAMS_SNAPPY --execute="$(<trino/import/raw_taxonomy.q)" --user gbif --password

log "Executing interp_geo.q"
/usr/local/gbif/trino.jar --insecure --debug --server "$TRINO_SERVER" --catalog=hive \
--schema="$DB" --session=$SESSION_PARAMS_SNAPPY --execute="$(<trino/import/interp_geo.q)" --user gbif --password

log "Executing interp_taxon.q"

# Use the webservice directly.
# (There's no use to the caching, every query is different. And it's a huge load on Varnish.)
#log 'Finding address of checklistbank-nub-ws'
#zk_servers=c5zk1.gbif.org,c5zk2.gbif.org,c5zk3.gbif.org
#clb_nub_zk_node=$(zookeeper-client -server $zk_servers ls /prod/services/checklistbank-nub-ws 2> /dev/null | grep --only-matching ........-....-....-....-............ | tail -n 1)
#clb_nub_host=$(zookeeper-client -server $zk_servers get /prod/services/checklistbank-nub-ws/$clb_nub_zk_node 2> /dev/null | grep $clb_nub_zk_node | tail -n 1 | jq -r .address)
#clb_nub_port=$(zookeeper-client -server $zk_servers get /prod/services/checklistbank-nub-ws/$clb_nub_zk_node 2> /dev/null | grep $clb_nub_zk_node | tail -n 1 | jq -r .port)
#clb_nub_location=http://$clb_nub_host:$clb_nub_port/
clb_nub_location=https://api.gbif-uat.org/v1/
log "Address is $clb_nub_location"

interp_taxon_file="trino/import/interp_taxon.q"
./trino/import/interp_taxon.sh $interp_taxon_file $clb_nub_location

/usr/local/gbif/trino.jar --insecure --debug --server "$TRINO_SERVER" --catalog=hive \
--schema="$DB" --session=$SESSION_PARAMS_SNAPPY --execute="$(<$interp_taxon_file)" --user gbif --password

log "Creating regions file"
./trino/import/create_regions.sh

# Create a directory for the regions file
log "Creating temp directory for regions file"
kubectl --kubeconfig="$KUBE_CONFIG" exec -n gbif-develop -it gbif-trino-worker-default-0 -- bash -c "mkdir -p /tmp/regions"
kubectl --kubeconfig="$KUBE_CONFIG" exec -n gbif-develop -it gbif-trino-coordinator-default-0 -- bash -c "mkdir -p /tmp/regions"

log "Copying regions file to the pods"
kubectl --kubeconfig="$KUBE_CONFIG" cp analytics_regions.tsv gbif-develop/gbif-trino-worker-default-0:/tmp/regions -c trino
kubectl --kubeconfig="$KUBE_CONFIG" cp analytics_regions.tsv gbif-develop/gbif-trino-coordinator-default-0:/tmp/regions -c trino

log "Executing region_table.q"
/usr/local/gbif/trino.jar --insecure --debug --server "$TRINO_SERVER" --catalog=hive \
--schema="$DB" --session=$SESSION_PARAMS_SNAPPY --execute="$(<trino/import/region_table.q)" --user gbif --password

log "Create occurrence tables"
./trino/import/create_occurrence_tables.sh "$DB" "$TRINO_SERVER" "$TRINO_PASSWORD"

