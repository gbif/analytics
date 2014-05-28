-- Static variables
CREATE DATABASE IF NOT EXISTS ${hiveconf:DB};

DROP TABLE IF EXISTS ${hiveconf:DB}.occ_country_kingdom_basisOfRecord;
CREATE TABLE ${hiveconf:DB}.occ_country_kingdom_basisOfRecord
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT 
  snapshot, 
  country, 
  COALESCE(kingdom_id, 0) AS kingdom_id,
  COALESCE(basis_of_record, "UNKNOWN") AS basis_of_record,
  COUNT(*) AS occurrence_count
FROM ${hiveconf:DB}.snapshots
GROUP BY 
  snapshot,
  country,
  COALESCE(kingdom_id, 0),
  COALESCE(basis_of_record, "UNKNOWN");

DROP TABLE IF EXISTS ${hiveconf:DB}.occ_publisherCountry_kingdom_basisOfRecord;
CREATE TABLE ${hiveconf:DB}.occ_publisherCountry_kingdom_basisOfRecord
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT 
  snapshot, 
  publisher_country, 
  COALESCE(kingdom_id, 0) AS kingdom_id,
  COALESCE(basis_of_record, "UNKNOWN") AS basis_of_record,
  COUNT(*) AS occurrence_count
FROM ${hiveconf:DB}.snapshots
GROUP BY 
  snapshot,
  publisher_country,
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