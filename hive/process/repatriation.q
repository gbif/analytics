CREATE DATABASE IF NOT EXISTS ${hiveconf:DB};

-- Set up memory for YARN
SET mapreduce.map.memory.mb = 4096;
SET mapreduce.reduce.memory.mb = 4096;
SET mapreduce.map.java.opts = -Xmx3072m;
SET mapreduce.reduce.java.opts = -Xmx3072m;


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


-- Species count in repatriated data follows
DROP TABLE IF EXISTS ${hiveconf:DB}.spe_country_repatriation;
CREATE TABLE ${hiveconf:DB}.spe_country_repatriation
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  t1.snapshot AS snapshot,
  t1.country As country,
  COUNT (DISTINCT national_species_id) AS national,
  COUNT (DISTINCT international_species_id) AS international
FROM (SELECT
    snapshot,
    country,
    CASE WHEN country=publisher_country THEN species_id ELSE NULL END AS national_species_id,
    CASE WHEN country!=publisher_country THEN species_id ELSE NULL END AS international_species_id
   FROM ${hiveconf:DB}.snapshots
   WHERE country IS NOT NULL AND publisher_country IS NOT NULL AND species_id IS NOT NULL
  ) t1
GROUP BY t1.snapshot,t1.country;

DROP TABLE IF EXISTS ${hiveconf:DB}.spe_publisherCountry_repatriation;
CREATE TABLE ${hiveconf:DB}.spe_publisherCountry_repatriation
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  t1.snapshot AS snapshot,
  t1.publisher_country As publisher_country,
  COUNT (DISTINCT national_species_id) AS national,
  COUNT (DISTINCT international_species_id) AS international
FROM (SELECT
    snapshot,
    publisher_country,
    CASE WHEN country=publisher_country THEN species_id ELSE NULL END AS national_species_id,
    CASE WHEN country!=publisher_country THEN species_id ELSE NULL END AS international_species_id
   FROM ${hiveconf:DB}.snapshots
   WHERE country IS NOT NULL AND publisher_country IS NOT NULL AND species_id IS NOT NULL
  ) t1
GROUP BY t1.snapshot,t1.publisher_country;

DROP TABLE IF EXISTS ${hiveconf:DB}.spe_repatriation;
CREATE TABLE ${hiveconf:DB}.spe_repatriation
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  t1.snapshot AS snapshot,
  COUNT (DISTINCT national_species_id) AS national,
  COUNT (DISTINCT international_species_id) AS international
FROM (SELECT
    snapshot,
    CASE WHEN country=publisher_country THEN species_id ELSE NULL END AS national_species_id,
    CASE WHEN country!=publisher_country THEN species_id ELSE NULL END AS international_species_id
   FROM ${hiveconf:DB}.snapshots
   WHERE country IS NOT NULL AND publisher_country IS NOT NULL AND species_id IS NOT NULL
  ) t1
GROUP BY t1.snapshot;
