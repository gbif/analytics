#!/bin/bash
# Generates the hive query that prepares the one big table of occurrences for subsequent hive processing. Single argument is the name of the "prepare.q" file
# Note that single ' and double " quotes are used carefully in the echos below - not arbitrarily.

prepare_file="$1"
DB="$2"

rm -f "$prepare_file"

declare -a snapshots=("20231208" "20231209")
max=$(( ${#snapshots[*]} - 1 ))
last_snapshot=${snapshots[$max]}

echo "--
-- Unions all the snapshots into a single table
--

DROP TABLE IF EXISTS $DB.snapshots;
CREATE TABLE $DB.snapshots
WITH (format = 'ORC')
AS
SELECT * FROM
(" > $prepare_file

for snapshot in "${snapshots[@]}"
do
  tmptable=${snapshot:0:4}-${snapshot:4:2}-${snapshot:6:2}
  echo "SELECT '${tmptable}'"' AS snapshot, CAST(id AS BIGINT) AS id, CAST(dataset_id AS varchar) AS dataset_id,
        CAST(publisher_id AS varchar) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species,
        scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record,
        latitude, longitude, country, day, month, year, publisher_country, gbif_region, publisher_gbif_region
        FROM snapshot.occurrence_'"$snapshot" >> $prepare_file
  if [[ $snapshot != $last_snapshot ]]; then
    echo "UNION ALL" >> $prepare_file
  fi
done

echo ") t1" >> "$prepare_file"
