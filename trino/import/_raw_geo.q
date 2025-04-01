--NOT USED ANYMORE

DROP TABLE IF EXISTS tmp_raw_geo;

SET SESSION hive.compression_codec='SNAPPY';

CREATE TABLE tmp_raw_geo
WITH (format = 'PARQUET')
AS
SELECT
  CONCAT_WS('|',
    t1.latitude,
    t1.longitude,
    t1.country
  ) AS geo_key,
  t1.latitude,
  t1.longitude,
  t1.country
FROM
(
 SELECT COALESCE(v_decimallatitude,v_verbatimlatitude,'') AS latitude, COALESCE(v_decimallongitude,v_verbatimlongitude,'') AS longitude, COALESCE(v_country,'') AS country
  FROM raw
  GROUP BY COALESCE(v_decimallatitude,v_verbatimlatitude,''), COALESCE(v_decimallongitude,v_verbatimlongitude,''), COALESCE(v_country,'')
) t1
GROUP BY t1.latitude, t1.longitude, t1.country
ORDER BY rand();



