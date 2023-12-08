#!/bin/bash -e

SNAPSHOT_NAME=$1

# Converting UK→GB is done to resolve https://dev.gbif.org/issues/browse/POR-2455/
# Snapshots up to 2010-07-26 contain UK values.
# (The tmp_geo_interp table keys contain UK for these values, and the gbif_region is also defined.)

echo "
DROP TABLE IF EXISTS snapshot.occurrence_$SNAPSHOT_NAME;

CREATE TABLE snapshot.occurrence_$SNAPSHOT_NAME
WITH (format = 'ORC')
AS
SELECT
  r.id,
  r.data_resource_id as dataset_id,
  r.data_provider_id as publisher_id,
  CASE WHEN p.iso_country_code = 'UK' THEN 'GB' ELSE p.iso_country_code END AS publisher_country,
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
  CASE WHEN g.country = 'UK' THEN 'GB' ELSE g.country END AS country,
  rc.gbif_region AS gbif_region,
  d.day,
  d.month,
  d.year
FROM
  (SELECT
    id,
    data_provider_id,
    data_resource_id,
    CONCAT_WS('|',
      COALESCE(kingdom, ''),
      COALESCE(phylum, ''),
      COALESCE(class_rank, ''),
      COALESCE(order_rank, ''),
      COALESCE(family, ''),
      COALESCE(genus, ''),
      COALESCE(scientific_name, ''),
      COALESCE(species,''),
      COALESCE(subspecies,''),
      COALESCE(author, ''),
      COALESCE(rank,'')
    ) as taxon_key,
    CONCAT_WS('|',
      COALESCE(latitude, ''),
      COALESCE(longitude, ''),
      COALESCE(country, '')
    ) as geo_key,
    parseDate(year,month,day,NULL) d,
    parseBoR(basis_of_record) as basis_of_record
  FROM snapshot.raw_$SNAPSHOT_NAME
  ) r
  JOIN snapshot.tmp_taxonomy_interp t ON t.taxon_key = r.taxon_key
  JOIN snapshot.tmp_geo_interp g ON g.geo_key = r.geo_key
  JOIN snapshot.publisher_$SNAPSHOT_NAME p ON r.data_provider_id=p.id
  LEFT JOIN snapshot.tmp_regions rc ON rc.country = g.country
  LEFT JOIN snapshot.tmp_regions rpc ON rpc.country = p.iso_country_code;
"
