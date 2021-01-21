CREATE DATABASE IF NOT EXISTS ${hiveconf:DB};

-- Set up memory for YARN
SET mapreduce.map.memory.mb = 4096;
SET mapreduce.reduce.memory.mb = 4096;
SET mapreduce.map.java.opts = -Xmx3072m;
SET mapreduce.reduce.java.opts = -Xmx3072m;

-- occ_country_repatriation
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_country_repatriation;
CREATE TABLE ${hiveconf:DB}.occ_country_repatriation
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  country,
  SUM(CASE WHEN country=publisher_country THEN 1 ELSE 0 END) AS national,
  SUM(CASE WHEN country!=publisher_country THEN 1 ELSE 0 END) AS international
FROM ${hiveconf:DB}.snapshots
WHERE country IS NOT NULL AND publisher_country IS NOT NULL
GROUP BY snapshot,country;

-- occ_publisherCountry_repatriation
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_publisherCountry_repatriation;
CREATE TABLE ${hiveconf:DB}.occ_publisherCountry_repatriation
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  publisher_country,
  SUM(CASE WHEN country=publisher_country THEN 1 ELSE 0 END) AS national,
  SUM(CASE WHEN country!=publisher_country THEN 1 ELSE 0 END) AS international
FROM ${hiveconf:DB}.snapshots
WHERE country IS NOT NULL AND publisher_country IS NOT NULL
GROUP BY snapshot,publisher_country;

-- occ_gbifRegion_repatriation
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_gbifRegion_repatriation;
CREATE TABLE ${hiveconf:DB}.occ_gbifRegion_repatriation
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  gbif_region,
  SUM(CASE WHEN country=publisher_country THEN 1 ELSE 0 END) AS national,
  SUM(CASE WHEN country!=publisher_country THEN 1 ELSE 0 END) AS international
FROM ${hiveconf:DB}.snapshots
WHERE gbif_region IS NOT NULL AND publisher_gbif_region IS NOT NULL
GROUP BY snapshot,gbif_region;

-- occ_publisherGbifRegion_repatriation
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_publisherGbifRegion_repatriation;
CREATE TABLE ${hiveconf:DB}.occ_publisherGbifRegion_repatriation
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  publisher_gbif_region,
  SUM(CASE WHEN country=publisher_country THEN 1 ELSE 0 END) AS national,
  SUM(CASE WHEN country!=publisher_country THEN 1 ELSE 0 END) AS international
FROM ${hiveconf:DB}.snapshots
WHERE gbif_region IS NOT NULL AND publisher_gbif_region IS NOT NULL
GROUP BY snapshot,publisher_gbif_region;

-- occ_repatriation
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_repatriation;
CREATE TABLE ${hiveconf:DB}.occ_repatriation
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  SUM(CASE WHEN country=publisher_country THEN 1 ELSE 0 END) AS national,
  SUM(CASE WHEN country!=publisher_country THEN 1 ELSE 0 END) AS international
FROM ${hiveconf:DB}.snapshots
WHERE country IS NOT NULL AND publisher_country IS NOT NULL
GROUP BY snapshot;
