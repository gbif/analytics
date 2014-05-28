CREATE DATABASE IF NOT EXISTS ${hiveconf:DB};

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

-- Various occurrence counts rolled up as global country
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_yearCollected;
CREATE TABLE ${hiveconf:DB}.occ_yearCollected
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT 
  snapshot, 
  year,
  SUM(count) AS count
FROM ${hiveconf:DB}.occ_country_yearCollected
GROUP BY snapshot,year;
