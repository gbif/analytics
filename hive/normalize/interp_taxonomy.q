-- Fix UDF classpath issues
SET mapreduce.task.classpath.user.precedence = true;
SET mapreduce.user.classpath.first=true;

-- Use Snappy
SET hive.exec.compress.output=true;
SET mapred.output.compression.type=BLOCK;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;

-- Use lots of mappers
SET mapred.map.tasks = ${hiveconf:mapcount};
SET hive.merge.mapfiles = false;
SET hive.input.format = org.apache.hadoop.hive.ql.io.HiveInputFormat;

ADD JAR ${hiveconf:occjar};
ADD JAR ${hiveconf:props};
CREATE TEMPORARY FUNCTION nubLookup AS 'org.gbif.occurrence.hive.udf.SpeciesMatchUDF';

DROP TABLE IF EXISTS snapshot.tmp_taxonomy_interp;
CREATE TABLE snapshot.tmp_taxonomy_interp STORED AS RCFILE AS
SELECT
  t1.taxon_key,
  n.kingdom as kingdom,
  n.phylum as phylum,
  n.class_rank as class_rank,
  n.order_rank as order_rank,
  n.family as family,
  n.genus as genus,
  n.species as species,
  n.scientific_name as scientific_name,
  n.kingdomKey as kingdom_id,
  n.phylumKey as phylum_id,
  n.classKey as class_id,
  n.orderKey as order_id,
  n.familyKey as family_id,
  n.genusKey as genus_id,
  n.speciesKey as species_id,
  n.taxonKey as taxon_id
FROM (
  SELECT
    taxon_key,
    nubLookup("${hiveconf:api}", kingdom, phylum, class_rank, order_rank, family, genus, scientific_name, null, null) n
  FROM snapshot.tmp_raw_taxonomy
) t1;
