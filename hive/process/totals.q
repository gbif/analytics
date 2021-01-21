CREATE DATABASE IF NOT EXISTS ${hiveconf:DB};

-- Set up memory for YARN
SET mapreduce.map.memory.mb = 4096;
SET mapreduce.reduce.memory.mb = 4096;
SET mapreduce.map.java.opts = -Xmx3072m;
SET mapreduce.reduce.java.opts = -Xmx3072m;

-- occ_country
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_country;
CREATE TABLE ${hiveconf:DB}.occ_country (
  snapshot STRING,
  country STRING,
  total_occurrences BIGINT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;

-- occ_publisherCountry
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_publisherCountry;
CREATE TABLE ${hiveconf:DB}.occ_publisherCountry  (
  snapshot STRING,
  publisher_country STRING,
  total_occurrences BIGINT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;

-- occ_gbifRegion
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_gbifRegion;
CREATE TABLE ${hiveconf:DB}.occ_gbifRegion (
  snapshot STRING,
  gbif_region STRING,
  total_occurrences BIGINT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;

-- occ_publisherGbifRegion
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_publisherGbifRegion;
CREATE TABLE ${hiveconf:DB}.occ_publisherGbifRegion  (
  snapshot STRING,
  publisher_gbif_region STRING,
  total_occurrences BIGINT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;

-- occ
DROP TABLE IF EXISTS ${hiveconf:DB}.occ;
CREATE TABLE ${hiveconf:DB}.occ  (
  snapshot STRING,
  total_occurrences BIGINT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;

FROM ${hiveconf:DB}.snapshots
INSERT INTO TABLE ${hiveconf:DB}.occ_country
  SELECT
    snapshot,
    country,
    COUNT(*) AS total_occurrences
  GROUP BY snapshot, country
INSERT INTO TABLE ${hiveconf:DB}.occ_publisherCountry
  SELECT
    snapshot,
    publisher_country,
    COUNT(*) AS total_occurrences
  GROUP BY snapshot, publisher_country
INSERT INTO TABLE ${hiveconf:DB}.occ_gbifRegion
  SELECT
    snapshot,
    gbif_region,
    COUNT(*) AS total_occurrences
  GROUP BY snapshot, gbif_region
INSERT INTO TABLE ${hiveconf:DB}.occ_publisherGbifRegion
  SELECT
    snapshot,
    publisher_gbif_region,
    COUNT(*) AS total_occurrences
  GROUP BY snapshot, publisher_gbif_region
INSERT INTO TABLE ${hiveconf:DB}.occ
  SELECT
    snapshot,
    COUNT(*) AS total_occurrences
  GROUP BY snapshot;

-- spe_country
DROP TABLE IF EXISTS ${hiveconf:DB}.spe_country;
CREATE TABLE ${hiveconf:DB}.spe_country
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  t1.snapshot AS snapshot,
  t1.country As country,
  COUNT (DISTINCT species_id) AS total_species
FROM (SELECT
    snapshot,
    country,
    species_id
   FROM ${hiveconf:DB}.snapshots
   WHERE species_id IS NOT NULL
  ) t1
GROUP BY t1.snapshot, t1.country;

-- spe_publisherCountry
DROP TABLE IF EXISTS ${hiveconf:DB}.spe_publisherCountry;
CREATE TABLE ${hiveconf:DB}.spe_publisherCountry
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  t1.snapshot AS snapshot,
  t1.publisher_country As publisher_country,
  COUNT (DISTINCT species_id) AS total_species
FROM (SELECT
    snapshot,
    publisher_country,
    species_id
   FROM ${hiveconf:DB}.snapshots
   WHERE species_id IS NOT NULL
  ) t1
GROUP BY t1.snapshot, t1.publisher_country;

-- spe_gbifRegion
DROP TABLE IF EXISTS ${hiveconf:DB}.spe_gbifRegion;
CREATE TABLE ${hiveconf:DB}.spe_gbifRegion
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  t1.snapshot AS snapshot,
  t1.gbif_region As gbif_region,
  COUNT (DISTINCT species_id) AS total_species
FROM (SELECT
    snapshot,
    gbif_region,
    species_id
   FROM ${hiveconf:DB}.snapshots
   WHERE species_id IS NOT NULL
  ) t1
GROUP BY t1.snapshot, t1.gbif_region;

-- spe_publisherGbifRegion
DROP TABLE IF EXISTS ${hiveconf:DB}.spe_publisherGbifRegion;
CREATE TABLE ${hiveconf:DB}.spe_publisherGbifRegion
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  t1.snapshot AS snapshot,
  t1.publisher_gbif_region As publisher_gbif_region,
  COUNT (DISTINCT species_id) AS total_species
FROM (SELECT
    snapshot,
    publisher_gbif_region,
    species_id
   FROM ${hiveconf:DB}.snapshots
   WHERE species_id IS NOT NULL
  ) t1
GROUP BY t1.snapshot, t1.publisher_gbif_region;

-- spe
DROP TABLE IF EXISTS ${hiveconf:DB}.spe;
CREATE TABLE ${hiveconf:DB}.spe
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  t1.snapshot AS snapshot,
  COUNT (DISTINCT species_id) AS total_species
FROM (SELECT
    snapshot,
    species_id
   FROM ${hiveconf:DB}.snapshots
   WHERE species_id IS NOT NULL
  ) t1
GROUP BY t1.snapshot;
