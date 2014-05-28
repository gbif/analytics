-- Use Snappy
SET hive.exec.compress.output=true;
SET mapred.output.compressiot.type=BLOCK;
SET mapred.output.compressiot.codec=org.apache.hadoop.io.compress.SnappyCodec;

CREATE TEMPORARY FUNCTION parseDate AS 'org.gbif.occurrence.hive.udf.DateParseUDF';
CREATE TEMPORARY FUNCTION parseBoR AS 'org.gbif.occurrence.hive.udf.BasisOfRecordParseUDF';

CREATE TABLE snapshot.occurrence_20130910 STORED AS rcfile AS
SELECT
  /*+ MAPJOIN(p) */
	r.id,
  r.data_resource_id as dataset_id,
  r.data_provider_id as publisher_id,	
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
  d.day,
  d.month,
  d.year,
  p.iso_country_code as publisher_country
FROM 
  (SELECT 
    id, 
    data_provider_id,
    data_resource_id,
    CONCAT_WS("|", 
      COALESCE(kingdom, ""),
      COALESCE(phylum, ""),
      COALESCE(class_rank, ""),
      COALESCE(order_rank, ""),
      COALESCE(family, ""),
      COALESCE(genus, ""),
      COALESCE(scientific_name, ""),
      COALESCE(author, "")  
    ) as taxon_key,
    CONCAT_WS("|", 
      COALESCE(latitude, ""),
      COALESCE(longitude, ""),
      COALESCE(country, "") 
    ) as geo_key,
    parseDate(year,month,day) d,
    parseBoR(basis_of_record) as basis_of_record
  FROM snapshot.raw_20130910 
  ) r
  JOIN taxonomy_20140419 t ON t.taxon_key = r.taxon_key
  JOIN geo_20140419 g ON g.geo_key = r.geo_key 
  JOIN publisher_20130910 p ON r.data_provider_id=p.id;
