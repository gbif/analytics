CREATE DATABASE IF NOT EXISTS ${hiveconf:DB};

DROP TABLE IF EXISTS ${hiveconf:DB}.occ_country_complete;
CREATE TABLE ${hiveconf:DB}.occ_country_complete
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT 
  snapshot, 
  country, 
  basis_of_record,
  COALESCE(
    CASE WHEN species_id IS NOT NULL AND species_id != taxon_id THEN 'Infraspecies' ELSE NULL END,
    CASE WHEN species_id IS NOT NULL THEN 'Species' ELSE NULL END,
    CASE WHEN genus_id IS NOT NULL THEN 'Genus' ELSE NULL END,
    CASE WHEN family_id IS NOT NULL THEN 'Family' ELSE NULL END,
    CASE WHEN order_id IS NOT NULL THEN 'Order' ELSE NULL END,
    CASE WHEN class_id IS NOT NULL THEN 'Class' ELSE NULL END,
    CASE WHEN phylum_id IS NOT NULL THEN 'Phylum' ELSE NULL END,
    CASE WHEN kingdom_id IS NOT NULL AND kingdom_id != 0 THEN 'Kingdom' ELSE NULL END,
    "Unknown"
  ) AS rank,
  COALESCE(
    CASE WHEN latitude IS NOT NULL AND longitude IS NOT NULL THEN 'Georeferenced' ELSE NULL END,
    CASE WHEN country IS NOT NULL THEN 'CountryOnly' ELSE NULL END,
    "Unknown"
  ) AS geospatial,
  COALESCE(
    CASE WHEN year IS NOT NULL AND month IS NOT NULL AND day IS NOT NULL THEN 'YearMonthDay' ELSE NULL END,
    CASE WHEN year IS NOT NULL AND month IS NOT NULL THEN 'YearMonth' ELSE NULL END,
    CASE WHEN year IS NOT NULL THEN 'YearOnly' ELSE NULL END,
    "Unknown"
  ) AS temporal,
  COUNT(*) AS count
FROM ${hiveconf:DB}.snapshots
GROUP BY 
  snapshot, 
  country, 
  basis_of_record,
  COALESCE(
    CASE WHEN species_id IS NOT NULL AND species_id != taxon_id THEN 'Infraspecies' ELSE NULL END,
    CASE WHEN species_id IS NOT NULL THEN 'Species' ELSE NULL END,
    CASE WHEN genus_id IS NOT NULL THEN 'Genus' ELSE NULL END,
    CASE WHEN family_id IS NOT NULL THEN 'Family' ELSE NULL END,
    CASE WHEN order_id IS NOT NULL THEN 'Order' ELSE NULL END,
    CASE WHEN class_id IS NOT NULL THEN 'Class' ELSE NULL END,
    CASE WHEN phylum_id IS NOT NULL THEN 'Phylum' ELSE NULL END,
    CASE WHEN kingdom_id IS NOT NULL AND kingdom_id != 0 THEN 'Kingdom' ELSE NULL END,
    "Unknown"
  ),
  COALESCE(
    CASE WHEN latitude IS NOT NULL AND longitude IS NOT NULL THEN 'Georeferenced' ELSE NULL END,
    CASE WHEN country IS NOT NULL THEN 'CountryOnly' ELSE NULL END,
    "Unknown"
  ),
  COALESCE(
    CASE WHEN year IS NOT NULL AND month IS NOT NULL AND day IS NOT NULL THEN 'YearMonthDay' ELSE NULL END,
    CASE WHEN year IS NOT NULL AND month IS NOT NULL THEN 'YearMonth' ELSE NULL END,
    CASE WHEN year IS NOT NULL THEN 'YearOnly' ELSE NULL END,
    "Unknown"
  );


DROP TABLE IF EXISTS ${hiveconf:DB}.occ_publisherCountry_complete;
CREATE TABLE ${hiveconf:DB}.occ_publisherCountry_complete
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT 
  snapshot, 
  publisher_country, 
  basis_of_record,
  COALESCE(
    CASE WHEN species_id IS NOT NULL AND species_id != taxon_id THEN 'Infraspecies' ELSE NULL END,
    CASE WHEN species_id IS NOT NULL THEN 'Species' ELSE NULL END,
    CASE WHEN genus_id IS NOT NULL THEN 'Genus' ELSE NULL END,
    CASE WHEN family_id IS NOT NULL THEN 'Family' ELSE NULL END,
    CASE WHEN order_id IS NOT NULL THEN 'Order' ELSE NULL END,
    CASE WHEN class_id IS NOT NULL THEN 'Class' ELSE NULL END,
    CASE WHEN phylum_id IS NOT NULL THEN 'Phylum' ELSE NULL END,
    CASE WHEN kingdom_id IS NOT NULL AND kingdom_id != 0 THEN 'Kingdom' ELSE NULL END,
    "Unknown"
  ) AS rank,
  COALESCE(
    CASE WHEN latitude IS NOT NULL AND longitude IS NOT NULL THEN 'Georeferenced' ELSE NULL END,
    CASE WHEN country IS NOT NULL THEN 'CountryOnly' ELSE NULL END,
    "Unknown"
  ) AS geospatial,
  COALESCE(
    CASE WHEN year IS NOT NULL AND month IS NOT NULL AND day IS NOT NULL THEN 'YearMonthDay' ELSE NULL END,
    CASE WHEN year IS NOT NULL AND month IS NOT NULL THEN 'YearMonth' ELSE NULL END,
    CASE WHEN year IS NOT NULL THEN 'YearOnly' ELSE NULL END,
    "Unknown"
  ) AS temporal,
  COUNT(*) AS count
FROM ${hiveconf:DB}.snapshots
GROUP BY 
  snapshot, 
  publisher_country, 
  basis_of_record,
  COALESCE(
    CASE WHEN species_id IS NOT NULL AND species_id != taxon_id THEN 'Infraspecies' ELSE NULL END,
    CASE WHEN species_id IS NOT NULL THEN 'Species' ELSE NULL END,
    CASE WHEN genus_id IS NOT NULL THEN 'Genus' ELSE NULL END,
    CASE WHEN family_id IS NOT NULL THEN 'Family' ELSE NULL END,
    CASE WHEN order_id IS NOT NULL THEN 'Order' ELSE NULL END,
    CASE WHEN class_id IS NOT NULL THEN 'Class' ELSE NULL END,
    CASE WHEN phylum_id IS NOT NULL THEN 'Phylum' ELSE NULL END,
    CASE WHEN kingdom_id IS NOT NULL AND kingdom_id != 0 THEN 'Kingdom' ELSE NULL END,
    "Unknown"
  ),
  COALESCE(
    CASE WHEN latitude IS NOT NULL AND longitude IS NOT NULL THEN 'Georeferenced' ELSE NULL END,
    CASE WHEN country IS NOT NULL THEN 'CountryOnly' ELSE NULL END,
    "Unknown"
  ),
  COALESCE(
    CASE WHEN year IS NOT NULL AND month IS NOT NULL AND day IS NOT NULL THEN 'YearMonthDay' ELSE NULL END,
    CASE WHEN year IS NOT NULL AND month IS NOT NULL THEN 'YearMonth' ELSE NULL END,
    CASE WHEN year IS NOT NULL THEN 'YearOnly' ELSE NULL END,
    "Unknown"
  );

DROP TABLE IF EXISTS ${hiveconf:DB}.occ_complete;
CREATE TABLE ${hiveconf:DB}.occ_complete
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT 
  snapshot, 
  basis_of_record,
  COALESCE(
    CASE WHEN species_id IS NOT NULL AND species_id != taxon_id THEN 'Infraspecies' ELSE NULL END,
    CASE WHEN species_id IS NOT NULL THEN 'Species' ELSE NULL END,
    CASE WHEN genus_id IS NOT NULL THEN 'Genus' ELSE NULL END,
    CASE WHEN family_id IS NOT NULL THEN 'Family' ELSE NULL END,
    CASE WHEN order_id IS NOT NULL THEN 'Order' ELSE NULL END,
    CASE WHEN class_id IS NOT NULL THEN 'Class' ELSE NULL END,
    CASE WHEN phylum_id IS NOT NULL THEN 'Phylum' ELSE NULL END,
    CASE WHEN kingdom_id IS NOT NULL AND kingdom_id != 0 THEN 'Kingdom' ELSE NULL END,
    "Unknown"
  ) AS rank,
  COALESCE(
    CASE WHEN latitude IS NOT NULL AND longitude IS NOT NULL THEN 'Georeferenced' ELSE NULL END,
    CASE WHEN country IS NOT NULL THEN 'CountryOnly' ELSE NULL END,
    "Unknown"
  ) AS geospatial,
  COALESCE(
    CASE WHEN year IS NOT NULL AND month IS NOT NULL AND day IS NOT NULL THEN 'YearMonthDay' ELSE NULL END,
    CASE WHEN year IS NOT NULL AND month IS NOT NULL THEN 'YearMonth' ELSE NULL END,
    CASE WHEN year IS NOT NULL THEN 'YearOnly' ELSE NULL END,
    "Unknown"
  ) AS temporal,
  COUNT(*) AS count
FROM ${hiveconf:DB}.snapshots
GROUP BY 
  snapshot, 
  basis_of_record,
  COALESCE(
    CASE WHEN species_id IS NOT NULL AND species_id != taxon_id THEN 'Infraspecies' ELSE NULL END,
    CASE WHEN species_id IS NOT NULL THEN 'Species' ELSE NULL END,
    CASE WHEN genus_id IS NOT NULL THEN 'Genus' ELSE NULL END,
    CASE WHEN family_id IS NOT NULL THEN 'Family' ELSE NULL END,
    CASE WHEN order_id IS NOT NULL THEN 'Order' ELSE NULL END,
    CASE WHEN class_id IS NOT NULL THEN 'Class' ELSE NULL END,
    CASE WHEN phylum_id IS NOT NULL THEN 'Phylum' ELSE NULL END,
    CASE WHEN kingdom_id IS NOT NULL AND kingdom_id != 0 THEN 'Kingdom' ELSE NULL END,
    "Unknown"
  ),
  COALESCE(
    CASE WHEN latitude IS NOT NULL AND longitude IS NOT NULL THEN 'Georeferenced' ELSE NULL END,
    CASE WHEN country IS NOT NULL THEN 'CountryOnly' ELSE NULL END,
    "Unknown"
  ),
  COALESCE(
    CASE WHEN year IS NOT NULL AND month IS NOT NULL AND day IS NOT NULL THEN 'YearMonthDay' ELSE NULL END,
    CASE WHEN year IS NOT NULL AND month IS NOT NULL THEN 'YearMonth' ELSE NULL END,
    CASE WHEN year IS NOT NULL THEN 'YearOnly' ELSE NULL END,
    "Unknown"
  );