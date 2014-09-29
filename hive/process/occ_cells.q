CREATE DATABASE IF NOT EXISTS ${hiveconf:DB};

DROP TABLE IF EXISTS ${hiveconf:DB}.occ_country_cell_one_deg;
CREATE TABLE ${hiveconf:DB}.occ_country_cell_one_deg
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT 
  t1.snapshot, 
  t1.country, 
  SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS one_cell,
  SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS under_twenty_cells,
  SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS under_hundred_cells,
  SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS under_thousand_cells,
  SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    country,
    species_id,
    COUNT(DISTINCT 
      CONCAT(
        CAST(floor(latitude) AS STRING),
        ",",
        CAST(floor(longitude) AS STRING)
      )
    ) AS num_cells
  FROM 
    ${hiveconf:DB}.snapshots
  WHERE
    species_id IS NOT NULL AND
    year IS NOT NULL AND year>1970 AND
    latitude IS NOT NULL AND longitude IS NOT NULL AND country IS NOT NULL
  GROUP BY
    snapshot,
    country,
    species_id) t1
GROUP BY
  t1.snapshot,
  t1.country;
  
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_publisherCountry_cell_one_deg;
CREATE TABLE ${hiveconf:DB}.occ_publisherCountry_cell_one_deg
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT 
  t1.snapshot, 
  t1.publisher_country, 
  SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS one_cell,
  SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS under_twenty_cells,
  SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS under_hundred_cells,
  SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS under_thousand_cells,
  SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    publisher_country,
    species_id,
    COUNT(DISTINCT 
      CONCAT(
        CAST(floor(latitude) AS STRING),
        ",",
        CAST(floor(longitude) AS STRING)
      )
    ) AS num_cells
  FROM 
    ${hiveconf:DB}.snapshots
  WHERE
    species_id IS NOT NULL AND
    year IS NOT NULL AND year>1970 AND
    latitude IS NOT NULL AND longitude IS NOT NULL AND publisher_country IS NOT NULL
  GROUP BY
    snapshot,
    publisher_country,
    species_id) t1
GROUP BY
  t1.snapshot,
  t1.publisher_country;
  
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_cell_one_deg;
CREATE TABLE ${hiveconf:DB}.occ_cell_one_deg
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT 
  t1.snapshot, 
  SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS one_cell,
  SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS under_twenty_cells,
  SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS under_hundred_cells,
  SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS under_thousand_cells,
  SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    species_id,
    COUNT(DISTINCT 
      CONCAT(
        CAST(floor(latitude) AS STRING),
        ",",
        CAST(floor(longitude) AS STRING)
      )
    ) AS num_cells
  FROM 
    ${hiveconf:DB}.snapshots
  WHERE
    species_id IS NOT NULL AND
    year IS NOT NULL AND year>1970 AND
    latitude IS NOT NULL AND longitude IS NOT NULL
  GROUP BY
    snapshot,
    species_id) t1
GROUP BY
  t1.snapshot;  
  
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_country_cell_point_one_deg;
CREATE TABLE ${hiveconf:DB}.occ_country_cell_point_one_deg
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT 
  t1.snapshot, 
  t1.country, 
  SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS one_cell,
  SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS under_twenty_cells,
  SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS under_hundred_cells,
  SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS under_thousand_cells,
  SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    country,
    species_id,
    COUNT(DISTINCT 
      CONCAT(
        CAST(floor(10*latitude) AS STRING),
        ",",
        CAST(floor(10*longitude) AS STRING)
      )
    ) AS num_cells
  FROM 
    ${hiveconf:DB}.snapshots
  WHERE
    species_id IS NOT NULL AND
    year IS NOT NULL AND year>1970 AND
    latitude IS NOT NULL AND longitude IS NOT NULL AND country IS NOT NULL
  GROUP BY
    snapshot,
    country,
    species_id) t1
GROUP BY
  t1.snapshot,
  t1.country;
  
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_publisherCountry_cell_point_one_deg;
CREATE TABLE ${hiveconf:DB}.occ_publisherCountry_cell_point_one_deg
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT 
  t1.snapshot, 
  t1.publisher_country, 
  SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS one_cell,
  SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS under_twenty_cells,
  SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS under_hundred_cells,
  SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS under_thousand_cells,
  SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    publisher_country,
    species_id,
    COUNT(DISTINCT 
      CONCAT(
        CAST(floor(10*latitude) AS STRING),
        ",",
        CAST(floor(10*longitude) AS STRING)
      )
    ) AS num_cells
  FROM 
    ${hiveconf:DB}.snapshots
  WHERE
    species_id IS NOT NULL AND
    year IS NOT NULL AND year>1970 AND
    latitude IS NOT NULL AND longitude IS NOT NULL AND publisher_country IS NOT NULL
  GROUP BY
    snapshot,
    publisher_country,
    species_id) t1
GROUP BY
  t1.snapshot,
  t1.publisher_country;
  
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_cell_point_one_deg;
CREATE TABLE ${hiveconf:DB}.occ_cell_point_one_deg
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT 
  t1.snapshot, 
  SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS one_cell,
  SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS under_twenty_cells,
  SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS under_hundred_cells,
  SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS under_thousand_cells,
  SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    species_id,
    COUNT(DISTINCT 
      CONCAT(
        CAST(floor(10*latitude) AS STRING),
        ",",
        CAST(floor(10*longitude) AS STRING)
      )
    ) AS num_cells
  FROM 
    ${hiveconf:DB}.snapshots
  WHERE
    species_id IS NOT NULL AND
    year IS NOT NULL AND year>1970 AND
    latitude IS NOT NULL AND longitude IS NOT NULL
  GROUP BY
    snapshot,
    species_id) t1
GROUP BY
  t1.snapshot;  
  
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_country_cell_half_deg;
CREATE TABLE ${hiveconf:DB}.occ_country_cell_half_deg
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT 
  t1.snapshot, 
  t1.country, 
  SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS one_cell,
  SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS under_twenty_cells,
  SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS under_hundred_cells,
  SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS under_thousand_cells,
  SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    country,
    species_id,
    COUNT(DISTINCT 
      CONCAT(
        CAST(floor(2*latitude) AS STRING),
        ",",
        CAST(floor(2*longitude) AS STRING)
      )
    ) AS num_cells
  FROM 
    ${hiveconf:DB}.snapshots
  WHERE
    species_id IS NOT NULL AND
    year IS NOT NULL AND year>1970 AND
    latitude IS NOT NULL AND longitude IS NOT NULL AND country IS NOT NULL
  GROUP BY
    snapshot,
    country,
    species_id) t1
GROUP BY
  t1.snapshot,
  t1.country;
  
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_publisherCountry_cell_half_deg;
CREATE TABLE ${hiveconf:DB}.occ_publisherCountry_cell_half_deg
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT 
  t1.snapshot, 
  t1.publisher_country, 
  SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS one_cell,
  SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS under_twenty_cells,
  SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS under_hundred_cells,
  SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS under_thousand_cells,
  SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    publisher_country,
    species_id,
    COUNT(DISTINCT 
      CONCAT(
        CAST(floor(2*latitude) AS STRING),
        ",",
        CAST(floor(2*longitude) AS STRING)
      )
    ) AS num_cells
  FROM 
    ${hiveconf:DB}.snapshots
  WHERE
    species_id IS NOT NULL AND
    year IS NOT NULL AND year>1970 AND
    latitude IS NOT NULL AND longitude IS NOT NULL AND publisher_country IS NOT NULL
  GROUP BY
    snapshot,
    publisher_country,
    species_id) t1
GROUP BY
  t1.snapshot,
  t1.publisher_country;
  
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_cell_half_deg;
CREATE TABLE ${hiveconf:DB}.occ_cell_half_deg
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT 
  t1.snapshot, 
  SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS one_cell,
  SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS under_twenty_cells,
  SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS under_hundred_cells,
  SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS under_thousand_cells,
  SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    species_id,
    COUNT(DISTINCT 
      CONCAT(
        CAST(floor(2*latitude) AS STRING),
        ",",
        CAST(floor(2*longitude) AS STRING)
      )
    ) AS num_cells
  FROM 
    ${hiveconf:DB}.snapshots
  WHERE
    species_id IS NOT NULL AND
    year IS NOT NULL AND year>1970 AND
    latitude IS NOT NULL AND longitude IS NOT NULL
  GROUP BY
    snapshot,
    species_id) t1
GROUP BY
  t1.snapshot;    
