CREATE DATABASE IF NOT EXISTS ${hiveconf:DB};

-- Set up memory for YARN
SET mapreduce.map.memory.mb = 4096;
SET mapreduce.reduce.memory.mb = 4096;
SET mapreduce.map.java.opts = -Xmx3072m;
SET mapreduce.reduce.java.opts = -Xmx3072m;


DROP TABLE IF EXISTS ${hiveconf:DB}.spe_country_kingdom;
CREATE TABLE ${hiveconf:DB}.spe_country_kingdom
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  country,
  COALESCE(kingdom_id, 0) AS kingdom_id,
  COUNT(DISTINCT species_id) AS species_count
FROM ${hiveconf:DB}.snapshots
WHERE species_id IS NOT NULL
GROUP BY
  snapshot,
  country,
  COALESCE(kingdom_id, 0);

DROP TABLE IF EXISTS ${hiveconf:DB}.spe_publisherCountry_kingdom;
CREATE TABLE ${hiveconf:DB}.spe_publisherCountry_kingdom
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  publisher_country,
  COALESCE(kingdom_id, 0) AS kingdom_id,
  COUNT(DISTINCT species_id) AS species_count
FROM ${hiveconf:DB}.snapshots
WHERE species_id IS NOT NULL
GROUP BY
  snapshot,
  publisher_country,
  COALESCE(kingdom_id, 0);

DROP TABLE IF EXISTS ${hiveconf:DB}.spe_kingdom;
CREATE TABLE ${hiveconf:DB}.spe_kingdom
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  COALESCE(kingdom_id, 0) AS kingdom_id,
  COUNT(DISTINCT species_id) AS species_count
FROM ${hiveconf:DB}.snapshots
WHERE species_id IS NOT NULL
GROUP BY
  snapshot,
  COALESCE(kingdom_id, 0);

DROP TABLE IF EXISTS ${hiveconf:DB}.spe_country_kingdom_observation;
CREATE TABLE ${hiveconf:DB}.spe_country_kingdom_observation
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  country,
  COALESCE(kingdom_id, 0) AS kingdom_id,
  COUNT(DISTINCT species_id) AS species_count
FROM ${hiveconf:DB}.snapshots
WHERE species_id IS NOT NULL AND basis_of_record IN('OBSERVATION', 'HUMAN_OBSERVATION', 'MACHINE_OBSERVATION')
GROUP BY
  snapshot,
  country,
  COALESCE(kingdom_id, 0);

DROP TABLE IF EXISTS ${hiveconf:DB}.spe_publisherCountry_kingdom_observation;
CREATE TABLE ${hiveconf:DB}.spe_publisherCountry_kingdom_observation
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  publisher_country,
  COALESCE(kingdom_id, 0) AS kingdom_id,
  COUNT(DISTINCT species_id) AS species_count
FROM ${hiveconf:DB}.snapshots
WHERE species_id IS NOT NULL AND basis_of_record IN('OBSERVATION', 'HUMAN_OBSERVATION', 'MACHINE_OBSERVATION')
GROUP BY
  snapshot,
  publisher_country,
  COALESCE(kingdom_id, 0);

DROP TABLE IF EXISTS ${hiveconf:DB}.spe_kingdom_observation;
CREATE TABLE ${hiveconf:DB}.spe_kingdom_observation
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  COALESCE(kingdom_id, 0) AS kingdom_id,
  COUNT(DISTINCT species_id) AS species_count
FROM ${hiveconf:DB}.snapshots
WHERE species_id IS NOT NULL AND basis_of_record IN('OBSERVATION', 'HUMAN_OBSERVATION', 'MACHINE_OBSERVATION')
GROUP BY
  snapshot,
  COALESCE(kingdom_id, 0);

DROP TABLE IF EXISTS ${hiveconf:DB}.spe_country_kingdom_specimen;
CREATE TABLE ${hiveconf:DB}.spe_country_kingdom_specimen
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  country,
  COALESCE(kingdom_id, 0) AS kingdom_id,
  COUNT(DISTINCT species_id) AS species_count
FROM ${hiveconf:DB}.snapshots
WHERE species_id IS NOT NULL AND basis_of_record IN('PRESERVED_SPECIMEN')
GROUP BY
  snapshot,
  country,
  COALESCE(kingdom_id, 0);

DROP TABLE IF EXISTS ${hiveconf:DB}.spe_publisherCountry_kingdom_specimen;
CREATE TABLE ${hiveconf:DB}.spe_publisherCountry_kingdom_specimen
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  publisher_country,
  COALESCE(kingdom_id, 0) AS kingdom_id,
  COUNT(DISTINCT species_id) AS species_count
FROM ${hiveconf:DB}.snapshots
WHERE species_id IS NOT NULL AND basis_of_record IN('PRESERVED_SPECIMEN')
GROUP BY
  snapshot,
  publisher_country,
  COALESCE(kingdom_id, 0);

DROP TABLE IF EXISTS ${hiveconf:DB}.spe_kingdom_specimen;
CREATE TABLE ${hiveconf:DB}.spe_kingdom_specimen
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  COALESCE(kingdom_id, 0) AS kingdom_id,
  COUNT(DISTINCT species_id) AS species_count
FROM ${hiveconf:DB}.snapshots
WHERE species_id IS NOT NULL AND basis_of_record IN('PRESERVED_SPECIMEN')
GROUP BY
  snapshot,
  COALESCE(kingdom_id, 0);
