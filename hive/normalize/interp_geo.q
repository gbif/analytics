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

ADD JAR ${hiveconf:epsgjar};
ADD JAR ${hiveconf:occjar};
ADD JAR ${hiveconf:props};
CREATE TEMPORARY FUNCTION parseGeo AS 'org.gbif.occurrence.hive.udf.CoordinateCountryParseUDF';

DROP TABLE IF EXISTS snapshot.tmp_geo_interp;
CREATE TABLE snapshot.tmp_geo_interp STORED AS RCFILE AS
SELECT 
  t1.geo_key,
  g.latitude, 
  g.longitude, 
  g.country
FROM (
  SELECT 
    geo_key, 
    parseGeo(${hiveconf:api},latitude, longitude, country) g
  FROM snapshot.tmp_raw_geo
) t1;
