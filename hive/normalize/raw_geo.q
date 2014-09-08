
-- Use Snappy
SET hive.exec.compress.output=true;
SET mapred.output.compression.type=BLOCK;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;

-- the union all means we can run in parallel
SET hive.exec.parallel=true;

DROP TABLE IF EXISTS snapshot.raw_geo;
CREATE TABLE snapshot.raw_geo STORED AS RCFILE AS
SELECT
  CONCAT_WS("|", 
    t1.latitude, 
    t1.longitude, 
    t1.country
  ) AS geo_key,
  t1.latitude, 
  t1.longitude, 
  t1.country
FROM 
  (

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20071219
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20080401
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20080627
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20081010
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20081217
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20090406
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20090617
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20090925
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20091216
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20100401
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20100726
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20101117
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20110221
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20110610
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20110905
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20120118
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20120326
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20120713
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20121031
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20121211
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20130220
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20130521
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20130709
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20130910
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20131220
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM raw_20140328
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL

  SELECT COALESCE(v_decimallatitude,v_verbatimlatitude,"") AS latitude, COALESCE(v_decimallongitude,v_verbatimlongitude,"") AS longitude, COALESCE(v_country,"") AS country
  FROM raw_20140908
  GROUP BY COALESCE(v_decimallatitude,v_verbatimlatitude,""), COALESCE(v_decimallongitude,v_verbatimlongitude,""), COALESCE(v_country,"")

) t1
GROUP BY t1.latitude,t1.longitude,t1.country;
