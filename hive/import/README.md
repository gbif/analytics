# Import

Sqoop:

sqoop import --connect jdbc:postgresql://excalibur.gbif.org/prod_registry --username registry \
 -P -m1 --hive-table snapshot.dataset_20140509 --create-hive-table --hive-import \
 --split-by key --target-dir /tmp/dataset_20140509 \
 --query "SELECT CAST(key AS VARCHAR) AS key, CAST(owning_organization_key AS VARCHAR) AS owning_organization_key, title FROM dataset WHERE deleted IS NULL AND \$CONDITIONS" 

sqoop import --connect jdbc:postgresql://excalibur.gbif.org/prod_registry --username registry \
 -P -m1 --hive-table snapshot.publisher_20140509 --create-hive-table --hive-import \
 --split-by key --target-dir /tmp/publisher_20140509 \
 --query "SELECT CAST(key AS VARCHAR) AS key, title, country FROM organization WHERE deleted IS NULL AND \$CONDITIONS" 


CREATE TABLE snapshot.occurrence_20140509 STORED AS rcfile AS
SELECT
  /*+ MAPJOIN(p) */
  o.gbifId AS id,
  o.datasetKey AS dataset_id,
  o.publishingOrgKey AS publisher_id,
  o.kingdom,
  o.phylum,
  o.class AS class_rank,
  o.order_ AS order_rank,
  o.family,
  o.genus,
  o.species,
  o.scientificName AS scientific_name,
  o.kingdomKey AS kingdom_id,
  o.phylumKey AS phylum_id,
  o.classKey AS class_id,
  o.orderKey AS order_id,
  o.familyKey AS family_id,
  o.genusKey AS genus_id,
  o.speciesKey AS species_id,
  o.taxonKey AS taxon_id,
  o.basisOfRecord AS basis_of_record,
  o.decimalLatitude AS latitude,
  o.decimalLongitude AS longitude,
  o.countryCode AS country,
  o.day,
  o.month,
  o.year,
  p.country AS publisher_country
FROM 
  prod_a.occurrence_hdfs o JOIN snapshot.publisher_20140509 p ON o.publishingOrgKey=p.key;
