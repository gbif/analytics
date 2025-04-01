#!/bin/bash -e

SNAPSHOT_NAME=$1

echo "
DROP TABLE IF EXISTS snapshot.occurrence_$SNAPSHOT_NAME;
CREATE TABLE snapshot.occurrence_$SNAPSHOT_NAME
WITH (format = 'PARQUET')
AS
SELECT
  r.id,
  r.dataset_id,
  r.publisher_id,
  r.publisher_country,
  rpc.gbif_region AS publisher_gbif_region,
  t.kingdom,
  t.phylum,
  t.class_rank,
  t.order_rank,
  t.family,
  t.genus,
  t.species,
  t.scientific_name,
  t.kingdom_id,
  t.phylum_id,
  t.class_id,
  t.order_id,
  t.family_id,
  t.genus_id,
  t.species_id,
  t.taxon_id,
  r.basis_of_record,
  g.latitude,
  g.longitude,
  g.country,
  rc.gbif_region AS gbif_region,
  d.day,
  d.month,
  d.year
  FROM
  (SELECT
   id,
   dataset_id,
   publisher_id,
   publisher_country,
   CONCAT_WS('|',
             COALESCE(kingdom, ''),
             COALESCE(phylum, ''),
             COALESCE(class_rank, ''),
             COALESCE(order_rank, ''),
             COALESCE(family, ''),
             COALESCE(genus, ''),
             COALESCE(scientific_name, ''),
             COALESCE(specific_epithet,''),
             COALESCE(infraspecific_epithet, ''),
             COALESCE(author, ''),
             COALESCE(taxon_rank,'')
   ) as taxon_key,
   CONCAT_WS('|',
             COALESCE(latitude, ''),
             COALESCE(longitude, ''),
             COALESCE(country, '')
   ) as geo_key,
   parseDate(year,month,day,event_date) d,
   parseBoR(basis_of_record) as basis_of_record
 FROM snapshot.raw_$SNAPSHOT_NAME
) r
JOIN snapshot.tmp_taxonomy_interp t ON t.taxon_key = r.taxon_key
JOIN snapshot.tmp_geo_interp g ON g.geo_key = r.geo_key
LEFT JOIN snapshot.tmp_regions rc ON rc.country = g.country
LEFT JOIN snapshot.tmp_regions rpc ON rpc.country = r.publisher_country;
"
