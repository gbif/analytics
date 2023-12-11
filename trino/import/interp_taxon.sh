#!/bin/bash

INTERP_TAXON_FILE=$1
API_URL=$2

echo "
DROP TABLE IF EXISTS snapshot.tmp_taxonomy_interp;
CREATE TABLE snapshot.tmp_taxonomy_interp
WITH (format = 'ORC')
AS
SELECT
  t1.taxon_key,
  n.kingdom as kingdom,
  n.phylum as phylum,
  n.class_ as class_rank,
  n.order_ as order_rank,
  n.family as family,
  n.genus as genus,
  n.species as species,
  n.scientificname as scientific_name,
  n.kingdomkey as kingdom_id,
  n.phylumkey as phylum_id,
  n.classkey as class_id,
  n.orderkey as order_id,
  n.familykey as family_id,
  n.genuskey as genus_id,
  n.specieskey as species_id,
  n.usageKey as taxon_id
FROM (
  SELECT
    taxon_key,
    nubLookup('$API_URL', kingdom, phylum, class_rank, order_rank, family, genus, scientific_name, specific_epithet, infra_specific_epithet, rank) n
  FROM tmp_raw_taxonomy
) t1;
" >> "$INTERP_TAXON_FILE"
