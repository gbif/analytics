DROP TABLE IF EXISTS occurrence_hdfs;

CREATE TABLE occurrence_hdfs
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
             COALESCE(v_kingdom, ''),
             COALESCE(v_phylum, ''),
             COALESCE(v_class, ''),
             COALESCE(v_order, ''),
             COALESCE(v_family, ''),
             COALESCE(v_genus, ''),
             COALESCE(v_scientificname, ''),
             COALESCE(v_specificepithet, ''),
             COALESCE(v_infraspecificepithet, ''),
             COALESCE(v_scientificnameauthorship, ''),
             COALESCE(v_taxonrank,'')
   ) as taxon_key,
   CONCAT_WS('|',
             COALESCE(v_decimallatitude,v_verbatimlatitude,''),
             COALESCE(v_decimallongitude,v_verbatimlongitude,''),
             COALESCE(v_country, '')
   ) as geo_key,
   parseDate(v_year,v_month,v_day,v_eventdate) d,
   parseBoR(v_basisofrecord) as basis_of_record
 FROM raw
) r
JOIN tmp_taxonomy_interp t ON t.taxon_key = r.taxon_key
JOIN tmp_geo_interp g ON g.geo_key = r.geo_key
LEFT JOIN tmp_regions rc ON rc.country = g.country
LEFT JOIN tmp_regions rpc ON rpc.country = r.publisher_country;

