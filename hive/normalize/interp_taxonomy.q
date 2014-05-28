-- Fix UDF classpath issues
SET mapreduce.task.classpath.user.precedence = true;
SET mapreduce.user.classpath.first=true;

-- Use Snappy
SET hive.exec.compress.output=true;
SET mapred.output.compression.type=BLOCK;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;

-- Use lots of mappers
mapred.map.tasks = 200;
hive.merge.mapfiles = false;
hive.input.format = org.apache.hadoop.hive.ql.io.HiveInputFormat;

ADD JAR /Users/tim/git/occurrence/occurrence-hive/target/occurrence-hive-0.17-SNAPSHOT-jar-with-dependencies.jar;
CREATE TEMPORARY FUNCTION nubLookup AS 'org.gbif.occurrence.hive.udf.NubLookupUDF';

CREATE TABLE snapshot.taxonomy_20140419 STORED AS RCFILE AS
SELECT 
  t1.taxon_key,
  n.kingdom as kingdom,
  n.phylum as phylum,
  n.classRank as class_rank,
  n.orderRank as order_rank,
  n.family as family,
  n.genus as genus,
  n.species as species,
  n.scientificName as scientific_name,
  n.nubKingdomId as kingdom_id,
  n.nubPhylumId as phylum_id,
  n.nubClassId as class_id,
  n.nubOrderId as order_id,
  n.nubFamilyId as family_id,
  n.nubGenusId as genus_id,
  n.nubSpeciesId as species_id,
  n.nubId as taxon_id
FROM (
  SELECT 
    taxon_key, 
    nubLookup(kingdom, phylum, class_rank, order_rank, family, genus, scientific_name, author) n
  FROM snapshot.raw_taxonomy
) t1;