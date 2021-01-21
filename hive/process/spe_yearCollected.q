CREATE DATABASE IF NOT EXISTS ${hiveconf:DB};

-- Set up memory for YARN
SET mapreduce.map.memory.mb = 4096;
SET mapreduce.reduce.memory.mb = 4096;
SET mapreduce.map.java.opts = -Xmx3072m;
SET mapreduce.reduce.java.opts = -Xmx3072m;

-- spe_country_yearCollected
DROP TABLE IF EXISTS ${hiveconf:DB}.spe_country_yearCollected;
CREATE TABLE ${hiveconf:DB}.spe_country_yearCollected
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  country,
  year,
  COUNT(DISTINCT species_id) AS count
FROM ${hiveconf:DB}.snapshots
WHERE year IS NOT NULL AND species_id IS NOT NULL
GROUP BY snapshot,country,year;

-- spe_publisherCountry_yearCollected
DROP TABLE IF EXISTS ${hiveconf:DB}.spe_publisherCountry_yearCollected;
CREATE TABLE ${hiveconf:DB}.spe_publisherCountry_yearCollected
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  publisher_country,
  year,
  COUNT(DISTINCT species_id) AS count
FROM ${hiveconf:DB}.snapshots
WHERE year IS NOT NULL AND species_id IS NOT NULL
GROUP BY snapshot,publisher_country,year;

-- spe_gbifRegion_yearCollected
DROP TABLE IF EXISTS ${hiveconf:DB}.spe_gbifRegion_yearCollected;
CREATE TABLE ${hiveconf:DB}.spe_gbifRegion_yearCollected
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  gbif_region,
  year,
  COUNT(DISTINCT species_id) AS count
FROM ${hiveconf:DB}.snapshots
WHERE year IS NOT NULL AND species_id IS NOT NULL
GROUP BY snapshot,gbif_region,year;

-- spe_publisherGbifRegion_yearCollected
DROP TABLE IF EXISTS ${hiveconf:DB}.spe_publisherGbifRegion_yearCollected;
CREATE TABLE ${hiveconf:DB}.spe_publisherGbifRegion_yearCollected
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  publisher_gbif_region,
  year,
  COUNT(DISTINCT species_id) AS count
FROM ${hiveconf:DB}.snapshots
WHERE year IS NOT NULL AND species_id IS NOT NULL
GROUP BY snapshot,publisher_gbif_region,year;

-- spe_yearCollected
DROP TABLE IF EXISTS ${hiveconf:DB}.spe_yearCollected;
CREATE TABLE ${hiveconf:DB}.spe_yearCollected
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  year,
  COUNT(DISTINCT species_id) AS count
FROM ${hiveconf:DB}.snapshots
WHERE year IS NOT NULL AND species_id IS NOT NULL
GROUP BY snapshot,year;
