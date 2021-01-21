CREATE DATABASE IF NOT EXISTS ${hiveconf:DB};

-- Set up memory for YARN
SET mapreduce.map.memory.mb = 4096;
SET mapreduce.reduce.memory.mb = 4096;
SET mapreduce.map.java.opts = -Xmx3072m;
SET mapreduce.reduce.java.opts = -Xmx3072m;

-- occ_country_yearCollected
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_country_yearCollected;
CREATE TABLE ${hiveconf:DB}.occ_country_yearCollected
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  country,
  year,
  COUNT(*) AS count
FROM ${hiveconf:DB}.snapshots
WHERE year IS NOT NULL
GROUP BY snapshot,country,year;

-- occ_publisherCountry_yearCollected
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_publisherCountry_yearCollected;
CREATE TABLE ${hiveconf:DB}.occ_publisherCountry_yearCollected
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  publisher_country,
  year,
  COUNT(*) AS count
FROM ${hiveconf:DB}.snapshots
WHERE year IS NOT NULL
GROUP BY snapshot,publisher_country,year;

-- occ_gbifRegion_yearCollected
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_gbifRegion_yearCollected;
CREATE TABLE ${hiveconf:DB}.occ_gbifRegion_yearCollected
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  gbif_region,
  year,
  COUNT(*) AS count
FROM ${hiveconf:DB}.snapshots
WHERE year IS NOT NULL
GROUP BY snapshot,gbif_region,year;

-- occ_publisherGbifRegion_yearCollected
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_publisherGbifRegion_yearCollected;
CREATE TABLE ${hiveconf:DB}.occ_publisherGbifRegion_yearCollected
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  publisher_gbif_region,
  year,
  COUNT(*) AS count
FROM ${hiveconf:DB}.snapshots
WHERE year IS NOT NULL
GROUP BY snapshot,publisher_gbif_region,year;

-- occ_yearCollected
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_yearCollected;
CREATE TABLE ${hiveconf:DB}.occ_yearCollected
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  year,
  SUM(count) AS count
FROM ${hiveconf:DB}.occ_country_yearCollected
GROUP BY snapshot,year;
