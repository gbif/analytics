-- Fix UDF classpath issues
SET mapreduce.task.classpath.user.precedence = true;
SET mapreduce.user.classpath.first=true;

-- Use Snappy
SET hive.exec.compress.output=true;
SET mapred.output.compression.type=BLOCK;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;

-- Set size, so we have relatively fewer mappers (limit is geocoder anyway).
SET mapred.map.tasks=40;
SET hive.merge.mapfiles = false;
SET hive.input.format=org.apache.hadoop.hive.ql.io.CombineHiveInputFormat;
SET mapred.min.split.size=128000000;

ADD JAR ${hiveconf:epsgjar};
ADD JAR ${hiveconf:occjar};
ADD JAR ${hiveconf:props};
CREATE TEMPORARY FUNCTION parseGeo AS 'org.gbif.occurrence.hive.udf.CoordinateCountryParseUDF';

DROP TABLE IF EXISTS snapshot.tmp_geo_interp;
CREATE TABLE snapshot.tmp_geo_interp STORED AS ORC AS
SELECT
  t1.geo_key,
  g.latitude,
  g.longitude,
  g.country
FROM (
  SELECT
    geo_key,
    parseGeo("${hiveconf:api}", latitude, longitude, country) g
  FROM snapshot.tmp_raw_geo
) t1;
