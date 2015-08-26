-- 
-- Unions all the snapshots into a single table
-- 

-- the union all means we can run in parallel
SET hive.exec.parallel=true;

-- Use Snappy
SET hive.exec.compress.output=true;
SET mapred.output.compressiot.type=BLOCK;
SET mapred.output.compressiot.codec=org.apache.hadoop.io.compress.SnappyCodec;

CREATE DATABASE IF NOT EXISTS ${hiveconf:DB};
DROP TABLE IF EXISTS ${hiveconf:DB}.snapshots;

CREATE TABLE ${hiveconf:DB}.snapshots STORED AS RCFILE AS
SELECT * FROM 
(
SELECT '2007-12-19' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20071219
UNION ALL
SELECT '2008-04-01' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20080401
UNION ALL
SELECT '2008-06-27' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20080627
UNION ALL
SELECT '2008-10-10' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20081010
UNION ALL
SELECT '2008-12-17' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20081217
UNION ALL
SELECT '2009-04-06' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20090406
UNION ALL
SELECT '2009-06-17' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20090617
UNION ALL
SELECT '2009-09-25' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20090925
UNION ALL
SELECT '2009-12-16' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20091216
UNION ALL
SELECT '2010-04-01' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20100401
UNION ALL
SELECT '2010-07-26' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20100726
UNION ALL
SELECT '2010-11-17' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20101117
UNION ALL
SELECT '2011-02-21' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20110221
UNION ALL
SELECT '2011-06-10' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20110610
UNION ALL
SELECT '2011-09-05' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20110905
UNION ALL
SELECT '2012-01-18' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20120118
UNION ALL
SELECT '2012-03-26' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20120326
UNION ALL
SELECT '2012-07-13' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20120713
UNION ALL
SELECT '2012-10-31' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20121031
UNION ALL
SELECT '2012-12-11' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20121211
UNION ALL
SELECT '2013-02-20' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20130220
UNION ALL
SELECT '2013-05-21' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20130521
UNION ALL
SELECT '2013-07-09' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20130709
UNION ALL
SELECT '2013-09-10' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20130910
UNION ALL
SELECT '2013-12-20' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20131220
UNION ALL
SELECT '2014-03-28' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20140328
UNION ALL
SELECT '2014-09-08' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20140908
UNION ALL
SELECT '2015-01-19' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20150119
UNION ALL
SELECT '2015-04-09' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20150409
UNION ALL
SELECT '2015-07-03' AS snapshot, id, CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_20150703
) t1
