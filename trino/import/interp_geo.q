DROP TABLE IF EXISTS snapshot.tmp_geo_interp;

CREATE TABLE snapshot.tmp_geo_interp
WITH (format = 'PARQUET')
AS
SELECT
  t1.geo_key,
  g.latitude,
  g.longitude,
  g.country
FROM (
  SELECT
    geo_key,
    parseGeo('/gbif/geocode-layers/geocode/layers/', latitude, longitude, country) g
  FROM snapshot.tmp_raw_geo
) t1;
