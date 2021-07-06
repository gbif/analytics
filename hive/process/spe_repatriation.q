CREATE DATABASE IF NOT EXISTS ${hiveconf:DB};

SET mapred.job.queue.name = root.default;

-- Set up memory for YARN
SET mapreduce.map.memory.mb = 4096;
SET mapreduce.reduce.memory.mb = 4096;
SET mapreduce.map.java.opts = -Xmx3072m;
SET mapreduce.reduce.java.opts = -Xmx3072m;

-- spe_country_repatriation
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

-- spe_publisherCountry_repatriation
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

-- spe_gbifRegion_repatriation
DROP TABLE IF EXISTS ${hiveconf:DB}.spe_gbifRegion_repatriation;
CREATE TABLE ${hiveconf:DB}.spe_gbifRegion_repatriation
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  t1.snapshot AS snapshot,
  t1.gbif_region As gbif_region,
  COUNT (DISTINCT national_species_id) AS national,
  COUNT (DISTINCT international_species_id) AS international
FROM (SELECT
    snapshot,
    gbif_region,
    CASE WHEN country=publisher_country THEN species_id ELSE NULL END AS national_species_id,
    CASE WHEN country!=publisher_country THEN species_id ELSE NULL END AS international_species_id
   FROM ${hiveconf:DB}.snapshots
   WHERE country IS NOT NULL AND publisher_country IS NOT NULL AND species_id IS NOT NULL
  ) t1
GROUP BY t1.snapshot,t1.gbif_region;

-- spe_publisherGbifRegion_repatriation
DROP TABLE IF EXISTS ${hiveconf:DB}.spe_publisherGbifRegion_repatriation;
CREATE TABLE ${hiveconf:DB}.spe_publisherGbifRegion_repatriation
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  t1.snapshot AS snapshot,
  t1.publisher_gbif_region As publisher_gbif_region,
  COUNT (DISTINCT national_species_id) AS national,
  COUNT (DISTINCT international_species_id) AS international
FROM (SELECT
    snapshot,
    publisher_gbif_region,
    CASE WHEN country=publisher_country THEN species_id ELSE NULL END AS national_species_id,
    CASE WHEN country!=publisher_country THEN species_id ELSE NULL END AS international_species_id
   FROM ${hiveconf:DB}.snapshots
   WHERE country IS NOT NULL AND publisher_country IS NOT NULL AND species_id IS NOT NULL
  ) t1
GROUP BY t1.snapshot,t1.publisher_gbif_region;

-- spe_repatriation
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
