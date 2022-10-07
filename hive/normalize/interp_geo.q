-- Fix UDF classpath issues
SET mapreduce.task.classpath.user.precedence = true;
SET mapreduce.user.classpath.first=true;

-- Use Snappy
SET hive.exec.compress.output=true;
SET mapred.output.compression.type=BLOCK;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;

-- Control the number of mappers.  About 50 meant this script completed in 2 minutes in 2022-10.
SET hive.input.format=org.apache.hadoop.hive.ql.io.CombineHiveInputFormat;
SET hive.merge.mapfiles = true;
SET mapreduce.input.fileinputformat.split.minsize = 20000000; -- 20 MB
SET mapreduce.input.fileinputformat.split.maxsize = 90000000; -- 90 MB

ADD JAR ${hiveconf:epsgjar};
ADD JAR ${hiveconf:occjar};
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
    parseGeo("${hiveconf:layerSource}", latitude, longitude, country) g
  FROM snapshot.tmp_raw_geo
) t1;
