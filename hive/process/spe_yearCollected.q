CREATE DATABASE IF NOT EXISTS ${hiveconf:DB};

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

-- Various occurrence counts rolled up as global country
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
