-- NOTE: "A SELECT statement can take regex-based column specification in Hive releases prior to 0.13.0, or in 0.13.0 and later releases if the configuration property hive.support.quoted.identifiers is set to none."
-- from https://cwiki.apache.org/confluence/display/Hive/LanguageManual+Select
-- this code tested on 0.10

-- schema as at 2013-12-20
DROP TABLE IF EXISTS restored_occurrence_hbase_20131220;
CREATE EXTERNAL TABLE restored_occurrence_hbase_20131220 (
  id INT,
  dataset_id STRING,
  publisher_id STRING,
  publisher_country STRING,
  institution_code STRING,
  collection_code STRING,
  catalog_number STRING,
  scientific_name STRING,
  author STRING,
  taxon_rank STRING,
  kingdom STRING,
  phylum STRING,
  class_rank STRING,
  order_rank STRING,
  family STRING,
  genus STRING,
  specific_epithet STRING,
  infraspecific_epithet STRING,
  latitude STRING,
  longitude STRING,
  coordinate_precision STRING,
  maximum_elevation_in_meters STRING,
  minimum_elevation_in_meters STRING,
  elevation_precision STRING,
  minimum_depth_in_meters STRING,
  maximum_depth_in_meters STRING,
  depth_precision STRING,
  continent_ocean STRING,
  state_province STRING,
  county STRING,
  country STRING,
  recorded_by STRING,
  locality STRING,
  year STRING,
  month STRING,
  day STRING,
  basis_of_record STRING,
  identified_by STRING,
  date_identified STRING,
  unit_qualifier STRING,
  created BIGINT,
  modified BIGINT
)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ("hbase.columns.mapping" = ":key#b,o:dk#s,o:ook#s,o:hc#s,o:ic#s,o:cc#s,o:cn#s,o:sn#s,o:a#s,o:r#s,o:k#s,o:p#s,o:c#s,o:o#s,o:f#s,o:g#s,o:s#s,o:ss#s,o:lat#s,o:lng#s,o:llp#s,o:maxa#s,o:mina#s,o:ap#s,o:mind#s,o:maxd#s,o:dp#s,o:co#s,o:sp#s,o:cty#s,o:ctry#s,o:coln#s,o:loc#s,o:y#s,o:m#s,o:d#s,o:bor#s,o:idn#s,o:idd#s,o:uq#s,o:crtd#b,o:mod#b")
TBLPROPERTIES(
  "hbase.table.name" = "restored_occurrence_hbase_20131220",
  "hbase.table.default.storage.type" = "binary"
);

DROP TABLE IF EXISTS raw_20131220;
CREATE TABLE raw_20131220 STORED AS RCFILE AS SELECT * FROM restored_occurrence_hbase_20131220;


-- schema as at 2014-03-28 (appears identical to 2013-12-20...)
DROP TABLE IF EXISTS restored_occurrence_hbase_20140328;
CREATE EXTERNAL TABLE restored_occurrence_hbase_20140328 (
  id INT,
  dataset_id STRING,
  publisher_id STRING,
  publisher_country STRING,
  institution_code STRING,
  collection_code STRING,
  catalog_number STRING,
  scientific_name STRING,
  author STRING,
  taxon_rank STRING,
  kingdom STRING,
  phylum STRING,
  class_rank STRING,
  order_rank STRING,
  family STRING,
  genus STRING,
  specific_epithet STRING,
  infraspecific_epithet STRING,
  latitude STRING,
  longitude STRING,
  coordinate_precision STRING,
  maximum_elevation_in_meters STRING,
  minimum_elevation_in_meters STRING,
  elevation_precision STRING,
  minimum_depth_in_meters STRING,
  maximum_depth_in_meters STRING,
  depth_precision STRING,
  continent_ocean STRING,
  state_province STRING,
  county STRING,
  country STRING,
  recorded_by STRING,
  locality STRING,
  year STRING,
  month STRING,
  day STRING,
  basis_of_record STRING,
  identified_by STRING,
  date_identified STRING,
  unit_qualifier STRING,
  created BIGINT,
  modified BIGINT
)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ("hbase.columns.mapping" = ":key#b,o:dk#s,o:ook#s,o:hc#s,o:ic#s,o:cc#s,o:cn#s,o:sn#s,o:a#s,o:r#s,o:k#s,o:p#s,o:c#s,o:o#s,o:f#s,o:g#s,o:s#s,o:ss#s,o:lat#s,o:lng#s,o:llp#s,o:maxa#s,o:mina#s,o:ap#s,o:mind#s,o:maxd#s,o:dp#s,o:co#s,o:sp#s,o:cty#s,o:ctry#s,o:coln#s,o:loc#s,o:y#s,o:m#s,o:d#s,o:bor#s,o:idn#s,o:idd#s,o:uq#s,o:crtd#b,o:mod#b")
TBLPROPERTIES(
  "hbase.table.name" = "restored_occurrence_hbase_20140328",
  "hbase.table.default.storage.type" = "binary"
);

DROP TABLE IF EXISTS raw_20140328;
CREATE TABLE raw_20140328 STORED AS RCFILE AS SELECT * FROM restored_occurrence_hbase_20140328;


-- schema as at 2014-09-08
DROP TABLE IF EXISTS raw_20140903;
DROP TABLE IF EXISTS raw_20140908;
CREATE TABLE raw_20140908 STORED AS RCFILE as select gbifid AS id, datasetkey AS dataset_id, publishingorgkey AS publisher_id, publishingcountry AS publisher_country, `v_.*` from prod_b.occurrence_hbase where datasetkey != 'ad43e954-dd79-4986-ae34-9ccdbd8bf568';
