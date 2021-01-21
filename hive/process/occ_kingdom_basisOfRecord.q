-- Static variables
CREATE DATABASE IF NOT EXISTS ${hiveconf:DB};

-- Set up memory for YARN
SET mapreduce.map.memory.mb = 4096;
SET mapreduce.reduce.memory.mb = 4096;
SET mapreduce.map.java.opts = -Xmx3072m;
SET mapreduce.reduce.java.opts = -Xmx3072m;

-- occ_country_kingdom_basisOfRecord
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_country_kingdom_basisOfRecord;
CREATE TABLE ${hiveconf:DB}.occ_country_kingdom_basisOfRecord (
  snapshot STRING,
  country STRING,
  kingdom_id INT,
  basis_of_record STRING,
  occurrence_count BIGINT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;

-- occ_publisherCountry_kingdom_basisOfRecord
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_publisherCountry_kingdom_basisOfRecord;
CREATE TABLE ${hiveconf:DB}.occ_publisherCountry_kingdom_basisOfRecord  (
  snapshot STRING,
  publisher_country STRING,
  kingdom_id INT,
  basis_of_record STRING,
  occurrence_count BIGINT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;

-- occ_gbifRegion_kingdom_basisOfRecord
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_gbifRegion_kingdom_basisOfRecord;
CREATE TABLE ${hiveconf:DB}.occ_gbifRegion_kingdom_basisOfRecord (
  snapshot STRING,
  gbif_region STRING,
  kingdom_id INT,
  basis_of_record STRING,
  occurrence_count BIGINT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;

-- occ_publisherGbifRegion_kingdom_basisOfRecord
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_publisherGbifRegion_kingdom_basisOfRecord;
CREATE TABLE ${hiveconf:DB}.occ_publisherGbifRegion_kingdom_basisOfRecord  (
  snapshot STRING,
  publisher_gbif_region STRING,
  kingdom_id INT,
  basis_of_record STRING,
  occurrence_count BIGINT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;

FROM ${hiveconf:DB}.snapshots
INSERT INTO TABLE ${hiveconf:DB}.occ_country_kingdom_basisOfRecord
  SELECT
    snapshot,
    country,
    COALESCE(kingdom_id, 0) AS kingdom_id,
    COALESCE(basis_of_record, "UNKNOWN") AS basis_of_record,
    COUNT(*) AS occurrence_count
  GROUP BY
    snapshot,
    country,
    COALESCE(kingdom_id, 0),
    COALESCE(basis_of_record, "UNKNOWN")
INSERT INTO TABLE ${hiveconf:DB}.occ_publisherCountry_kingdom_basisOfRecord
  SELECT
    snapshot,
    publisher_country,
    COALESCE(kingdom_id, 0) AS kingdom_id,
    COALESCE(basis_of_record, "UNKNOWN") AS basis_of_record,
    COUNT(*) AS occurrence_count
  GROUP BY
    snapshot,
    publisher_country,
    COALESCE(kingdom_id, 0),
    COALESCE(basis_of_record, "UNKNOWN")
INSERT INTO TABLE ${hiveconf:DB}.occ_gbifRegion_kingdom_basisOfRecord
  SELECT
    snapshot,
    gbif_region,
    COALESCE(kingdom_id, 0) AS kingdom_id,
    COALESCE(basis_of_record, "UNKNOWN") AS basis_of_record,
    COUNT(*) AS occurrence_count
  GROUP BY
    snapshot,
    gbif_region,
    COALESCE(kingdom_id, 0),
    COALESCE(basis_of_record, "UNKNOWN")
INSERT INTO TABLE ${hiveconf:DB}.occ_publisherGbifRegion_kingdom_basisOfRecord
  SELECT
    snapshot,
    publisher_gbif_region,
    COALESCE(kingdom_id, 0) AS kingdom_id,
    COALESCE(basis_of_record, "UNKNOWN") AS basis_of_record,
    COUNT(*) AS occurrence_count
  GROUP BY
    snapshot,
    publisher_gbif_region,
    COALESCE(kingdom_id, 0),
    COALESCE(basis_of_record, "UNKNOWN");

DROP TABLE IF EXISTS ${hiveconf:DB}.occ_kingdom_basisOfRecord;
CREATE TABLE ${hiveconf:DB}.occ_kingdom_basisOfRecord
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  kingdom_id,
  basis_of_record,
  SUM(occurrence_count) AS occurrence_count
FROM ${hiveconf:DB}.occ_country_kingdom_basisOfRecord
GROUP BY
  snapshot, kingdom_id, basis_of_record;
