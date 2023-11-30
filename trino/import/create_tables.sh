#!/bin/bash -e

DB=$1
export TRINO_PASSWORD=$2
KUBE_CONFIG=$3

SESSION_PARAMS="hive.compression_codec=SNAPPY"

# Create schema first if it doesn't exist
echo "Creating schema $DB"
/Users/marcoslopezgonzalez/dev/gbif/trino/trino.jar --insecure --debug --server https://localhost:8443 --catalog=hive \
--session=$SESSION_PARAMS \
--execute="CREATE SCHEMA IF NOT EXISTS $DB with (LOCATION='hdfs://gbif-hdfs/stackable/warehouse/$DB.db');" \
--user gbif --password

echo "Executing raw.q"
/Users/marcoslopezgonzalez/dev/gbif/trino/trino.jar --insecure --debug --server https://localhost:8443 --catalog=hive \
--schema=$DB --session=$SESSION_PARAMS --execute="$(<raw.q)" --user gbif --password

echo "Executing raw_geo.q"
/Users/marcoslopezgonzalez/dev/gbif/trino/trino.jar --insecure --debug --server https://localhost:8443 --catalog=hive \
--schema=$DB --session=$SESSION_PARAMS --execute="$(<raw_geo.q)" --user gbif --password

echo "Executing raw_taxon.q"
/Users/marcoslopezgonzalez/dev/gbif/trino/trino.jar --insecure --debug --server https://localhost:8443 --catalog=hive \
--schema=$DB --session=$SESSION_PARAMS --execute="$(<raw_taxon.q)" --user gbif --password

echo "Executing interp_geo.q"
/Users/marcoslopezgonzalez/dev/gbif/trino/trino.jar --insecure --debug --server https://localhost:8443 --catalog=hive \
--schema=$DB --session=$SESSION_PARAMS --execute="$(<interp_geo.q)" --user gbif --password

echo "Executing interp_taxon.q"
/Users/marcoslopezgonzalez/dev/gbif/trino/trino.jar --insecure --debug --server https://localhost:8443 --catalog=hive \
--schema=$DB --session=$SESSION_PARAMS --execute="$(<interp_taxon.q)" --user gbif --password

echo "Creating regions file"
./create_regions.sh

# Create a directory for the regions file
echo "Creating temp directory for regions file"
kubectl --kubeconfig=$KUBE_CONFIG exec -n gbif-develop -it gbif-trino-worker-default-0 -- bash -c "mkdir -p /tmp/regions"
kubectl --kubeconfig=$KUBE_CONFIG exec -n gbif-develop -it gbif-trino-coordinator-default-0 -- bash -c "mkdir -p /tmp/regions"

echo "Copying regions file to the pods"
kubectl --kubeconfig=$KUBE_CONFIG cp analytics_regions.tsv gbif-develop/gbif-trino-worker-default-0:/tmp/regions -c trino
kubectl --kubeconfig=$KUBE_CONFIG cp analytics_regions.tsv gbif-develop/gbif-trino-coordinator-default-0:/tmp/regions -c trino

echo "Executing region_table.q"
/Users/marcoslopezgonzalez/dev/gbif/trino/trino.jar --insecure --debug --server https://localhost:8443 --catalog=hive \
--schema=$DB --session=$SESSION_PARAMS --execute="$(<region_table.q)" --user gbif --password

echo "Executing occurrence_hdfs.q"
/Users/marcoslopezgonzalez/dev/gbif/trino/trino.jar --insecure --debug --server https://localhost:8443 --catalog=hive \
--schema=$DB --session=$SESSION_PARAMS --execute="$(<occurrence_hdfs.q)" --user gbif --password

echo "Executing create_snapshots_table.q"
/Users/marcoslopezgonzalez/dev/gbif/trino/trino.jar --insecure --debug --server https://localhost:8443 --catalog=hive \
--schema=$DB --session=$SESSION_PARAMS --execute="$(<create_snapshots_table.q)" --user gbif --password

files=`find ../process -name '*.q'`
for f in $files
do
  echo "Executing $f"
	/Users/marcoslopezgonzalez/dev/gbif/trino/trino.jar --insecure --debug --server https://localhost:8443 --catalog=hive \
  --schema=$DB --session=$SESSION_PARAMS --execute="$(<$f)" --user gbif --password
done
