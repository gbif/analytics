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
CREATE TEMPORARY FUNCTION parseGeo AS 'org.gbif.occurrence.hive.udf.CoordinateCountryParseUDF';



CREATE TABLE snapshot.geo_20140419 STORED AS RCFILE AS
SELECT 
  t1.geo_key,
  g.latitude, 
  g.longitude, 
  g.country
FROM (
  SELECT 
    geo_key, 
    parseGeo(latitude, longitude, country) g
  FROM snapshot.raw_geo
) t1;