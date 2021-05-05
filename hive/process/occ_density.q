CREATE DATABASE IF NOT EXISTS ${hiveconf:DB};

-- Set up memory for YARN
SET mapreduce.map.memory.mb = 4096;
SET mapreduce.reduce.memory.mb = 4096;
SET mapreduce.map.java.opts = -Xmx3072m;
SET mapreduce.reduce.java.opts = -Xmx3072m;

-- occ_density_country_point_one_deg
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_density_country_point_one_deg;
CREATE TABLE ${hiveconf:DB}.occ_density_country_point_one_deg
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  country,
  LEAST(FLOOR(10 * latitude) / 10, 89.9) AS latitude,
  FLOOR(10 * ((longitude + 180) % 360 - 180)) / 10 AS longitude,
  COUNT(*)
FROM
  ${hiveconf:DB}.snapshots
WHERE
  latitude IS NOT NULL AND longitude IS NOT NULL AND country IS NOT NULL
GROUP BY
  snapshot,
  country,
  LEAST(FLOOR(10 * latitude) / 10, 89.9),
  FLOOR(10 * ((longitude + 180) % 360 - 180)) / 10;

-- occ_density_publisherCountry_point_one_deg
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_density_publisherCountry_point_one_deg;
CREATE TABLE ${hiveconf:DB}.occ_density_publisherCountry_point_one_deg
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  publisher_country,
  LEAST(FLOOR(10 * latitude) / 10, 89.9) AS latitude,
  FLOOR(10 * ((longitude + 180) % 360 - 180)) / 10 AS longitude,
  COUNT(*)
FROM
  ${hiveconf:DB}.snapshots
WHERE
  latitude IS NOT NULL AND longitude IS NOT NULL AND publisher_country IS NOT NULL
GROUP BY
  snapshot,
  publisher_country,
  LEAST(FLOOR(10 * latitude) / 10, 89.9),
  FLOOR(10 * ((longitude + 180) % 360 - 180)) / 10;

-- occ_density_gbifRegion_point_one_deg
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_density_gbifRegion_point_one_deg;
CREATE TABLE ${hiveconf:DB}.occ_density_gbifRegion_point_one_deg
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  gbif_region,
  LEAST(FLOOR(10 * latitude) / 10, 89.9) AS latitude,
  FLOOR(10 * ((longitude + 180) % 360 - 180)) / 10 AS longitude,
  COUNT(*)
FROM
  ${hiveconf:DB}.snapshots
WHERE
  latitude IS NOT NULL AND longitude IS NOT NULL AND gbif_region IS NOT NULL
GROUP BY
  snapshot,
  gbif_region,
  LEAST(FLOOR(10 * latitude) / 10, 89.9),
  FLOOR(10 * ((longitude + 180) % 360 - 180)) / 10;

-- occ_density_publisherGbifRegion_point_one_deg
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_density_publisherGbifRegion_point_one_deg;
CREATE TABLE ${hiveconf:DB}.occ_density_publisherGbifRegion_point_one_deg
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  publisher_gbif_region,
  LEAST(FLOOR(10 * latitude) / 10, 89.9) AS latitude,
  FLOOR(10 * ((longitude + 180) % 360 - 180)) / 10 AS longitude,
  COUNT(*)
FROM
  ${hiveconf:DB}.snapshots
WHERE
  latitude IS NOT NULL AND longitude IS NOT NULL AND publisher_gbif_region IS NOT NULL
GROUP BY
  snapshot,
  publisher_gbif_region,
  LEAST(FLOOR(10 * latitude) / 10, 89.9),
  FLOOR(10 * ((longitude + 180) % 360 - 180)) / 10;

-- occ_density_point_one_deg
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_density_point_one_deg;
CREATE TABLE ${hiveconf:DB}.occ_density_point_one_deg
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  LEAST(FLOOR(10 * latitude) / 10, 89.9) AS latitude,
  FLOOR(10 * ((longitude + 180) % 360 - 180)) / 10 AS longitude,
  COUNT(*)
FROM
  ${hiveconf:DB}.snapshots
WHERE
  latitude IS NOT NULL AND longitude IS NOT NULL
GROUP BY
  snapshot,
  LEAST(FLOOR(10 * latitude) / 10, 89.9),
  FLOOR(10 * ((longitude + 180) % 360 - 180)) / 10;
