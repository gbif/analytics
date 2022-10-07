-- Fix UDF classpath issues
SET mapreduce.task.classpath.user.precedence = true;
SET mapreduce.user.classpath.first=true;

-- Use Snappy
SET hive.exec.compress.output=true;
SET mapred.output.compression.type=BLOCK;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;

-- Control the number of mappers.  This gave 21 for the 2022-10 analytics.
SET hive.input.format = org.apache.hadoop.hive.ql.io.CombineHiveInputFormat;
SET hive.merge.mapfiles = true;
SET mapreduce.input.fileinputformat.split.minsize = 20000000; -- 20 MB
SET mapreduce.input.fileinputformat.split.maxsize = 90000000; -- 90 MB

ADD JAR ${hiveconf:occjar};
CREATE TEMPORARY FUNCTION nubLookup AS 'org.gbif.occurrence.hive.udf.SpeciesMatchUDF';

DROP TABLE IF EXISTS snapshot.tmp_taxonomy_interp;
CREATE TABLE snapshot.tmp_taxonomy_interp STORED AS ORC AS
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
  n.taxonkey as taxon_id
FROM (
  SELECT
    taxon_key,
    nubLookup("${hiveconf:api}", kingdom, phylum, class_rank, order_rank, family, genus, scientific_name, specific_epithet, infra_specific_epithet, rank) n
  FROM snapshot.tmp_raw_taxonomy
) t1;
