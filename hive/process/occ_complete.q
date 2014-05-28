CREATE DATABASE IF NOT EXISTS ${hiveconf:DB};

DROP TABLE IF EXISTS ${hiveconf:DB}.occ_country_basisOfRecord_complete;
CREATE TABLE ${hiveconf:DB}.occ_country_basisOfRecord_complete
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT 
  snapshot, 
  country, 
  basis_of_record,
  SUM(
    CASE WHEN
      species_id IS NOT NULL AND
      latitude IS NOT NULL AND
      longitude IS NOT NULL AND
      year IS NOT NULL AND
      month IS NOT NULL AND
      day IS NOT NULL AND 
      basis_of_record IS NOT NULL AND
      basis_of_record != "UNKNOWN"
    THEN 1 ELSE 0 END
  ) AS complete,
  COUNT(*) AS total
FROM ${hiveconf:DB}.snapshots
GROUP BY snapshot,country,basis_of_record;

DROP TABLE IF EXISTS ${hiveconf:DB}.occ_publisherCountry_basisOfRecord_complete;
CREATE TABLE ${hiveconf:DB}.occ_publisherCountry_basisOfRecord_complete
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT 
  snapshot, 
  publisher_country, 
  basis_of_record,
  SUM(
    CASE WHEN
      species_id IS NOT NULL AND
      latitude IS NOT NULL AND
      longitude IS NOT NULL AND
      year IS NOT NULL AND
      month IS NOT NULL AND
      day IS NOT NULL AND 
      basis_of_record IS NOT NULL AND
      basis_of_record != "UNKNOWN"
    THEN 1 ELSE 0 END
  ) AS complete,
  COUNT(*) AS total
FROM ${hiveconf:DB}.snapshots
GROUP BY snapshot,publisher_country,basis_of_record;

-- Various occurrence counts rolled up as global country
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_basisOfRecord_complete;
CREATE TABLE ${hiveconf:DB}.occ_basisOfRecord_complete
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT 
  snapshot, 
  basis_of_record,
  SUM(complete) AS complete,
  SUM(total) AS total
FROM ${hiveconf:DB}.occ_country_basisOfRecord_complete
GROUP BY snapshot,basis_of_record;