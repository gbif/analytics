
--
-- A Hive script to support the analytics for the GBIF Sweden group
--


--
-- TODOS: 
--   insert variables for DB, tables etc
--   verify the EU country codes capture all of europe
--   lumping observations together in basisOfRecord into simpler categories 
--   insert the create tables for the pollinators and invasives

--
-- Count of records and species occurring within Europe for various dimensions
--
CREATE TABLE sweden.query1 
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
AS SELECT
  snapshot,
  kingdom,
  phylum,
  class_rank,
  country,
  latitude IS NOT NULL AS georeferenced,
  latitude IS NULL AS notGeoreferenced,
  year,
  CASE basis_of_record 
    WHEN 'MACHINE_OBSERVATION' THEN 'OBSERVATION' 
    WHEN 'HUMAN_OBSERVATION' THEN 'OBSERVATION' 
    ELSE basis_of_record
  END as basis_of_record,
  COUNT(*) AS occurrenceCount,
  COUNT(DISTINCT species_id) AS speciesCount
FROM analytics.snapshots
WHERE 
  country IN ('AL','AD','AM','AT','AZ','BY','BE','BA','BG','HR','CY','CZ',
    'DK','EE','FI','FR','GE','DE','GR','HU','IS','IE','IT','LV',
    'LI','LT','LU','MK','MT','MD','ME','NL','NO','PL','PT','RO',
    'RU','RS','SK','SI','ES','SE','CH','TR','UA','GB','AX','FO',
    'GI','GG','VA','IM','JE','KZ','MC','SM','SJ')
GROUP BY 
  snapshot,
  kingdom,
  phylum,
  class_rank,
  country,
  latitude IS NOT NULL,
  latitude IS NULL,
  year,
  CASE basis_of_record 
    WHEN 'MACHINE_OBSERVATION' THEN 'OBSERVATION' 
    WHEN 'HUMAN_OBSERVATION' THEN 'OBSERVATION' 
    ELSE basis_of_record
  END;


--
-- Count of records and species published by European institutions for various dimensions
--
CREATE TABLE sweden.query2
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
AS SELECT
  snapshot,
  kingdom,
  phylum,
  class_rank,
  publisher_country,
  latitude IS NOT NULL AS georeferenced,
  latitude IS NULL AS notGeoreferenced,
  year,
  CASE basis_of_record 
    WHEN 'MACHINE_OBSERVATION' THEN 'OBSERVATION' 
    WHEN 'HUMAN_OBSERVATION' THEN 'OBSERVATION' 
    ELSE basis_of_record
  END as basis_of_record,
  COUNT(*) AS occurrenceCount,
  COUNT(DISTINCT species_id) AS speciesCount
FROM analytics.snapshots
WHERE 
  publisher_country IN ('AL','AD','AM','AT','AZ','BY','BE','BA','BG','HR','CY','CZ',
    'DK','EE','FI','FR','GE','DE','GR','HU','IS','IE','IT','LV',
    'LI','LT','LU','MK','MT','MD','ME','NL','NO','PL','PT','RO',
    'RU','RS','SK','SI','ES','SE','CH','TR','UA','GB','AX','FO',
    'GI','GG','VA','IM','JE','KZ','MC','SM','SJ')
GROUP BY 
  snapshot,
  kingdom,
  phylum,
  class_rank,
  publisher_country,
  latitude IS NOT NULL,
  latitude IS NULL,
  year,
  CASE basis_of_record 
    WHEN 'MACHINE_OBSERVATION' THEN 'OBSERVATION' 
    WHEN 'HUMAN_OBSERVATION' THEN 'OBSERVATION' 
    ELSE basis_of_record
  END;
  
---
-- A list of families with count of species within, and a count of occurrence records for
-- class Insecta (216) or class Entognatha(290) derived from the occurrence records within 
-- Sweden.
---
CREATE TABLE sweden.query3
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
AS SELECT
  snapshot,
  kingdom,
  phylum,
  class_rank,
  order_rank,
  family,
  latitude IS NOT NULL AS georeferenced,
  year,
  CASE basis_of_record 
    WHEN 'MACHINE_OBSERVATION' THEN 'OBSERVATION' 
    WHEN 'HUMAN_OBSERVATION' THEN 'OBSERVATION' 
    ELSE basis_of_record
  END as basis_of_record,
  COUNT(*) AS occurrenceCount,
  COUNT(DISTINCT species_id) AS speciesCount
FROM analytics.snapshots
WHERE country='SE'
GROUP BY
  snapshot,
  kingdom,
  phylum,
  class_rank,
  order_rank,
  family,
  (latitude IS NOT NULL),
  year,
  CASE basis_of_record 
    WHEN 'MACHINE_OBSERVATION' THEN 'OBSERVATION' 
    WHEN 'HUMAN_OBSERVATION' THEN 'OBSERVATION' 
    ELSE basis_of_record
  END;

---
-- TODO insert the create table definitions for the taxonomy and the pollinators tables
-- here.
---


---
-- Location of occurrences per species per year for pollinating bees.
--    Andrenidae 7901
--    Apidae 4334
--    Colletidae 7905
--    Halictidae 7908
--    Megachilidae 7911
--    Melittidae 4345
--    Paleomelittidae 4298477
--    Stenotritidae 7916
---
CREATE TABLE sweden.query4
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
AS SELECT
  snapshot,
  kingdom,
  phylum,
  class_rank,
  order_rank,
  family,
  genus,
  scientific_name,
  country,
  latitude,
  longitude,
  year,
  CASE basis_of_record 
    WHEN 'MACHINE_OBSERVATION' THEN 'OBSERVATION' 
    WHEN 'HUMAN_OBSERVATION' THEN 'OBSERVATION' 
    ELSE basis_of_record
  END as basis_of_record,  
  publisher_id,
  publisher_country,
  COUNT(*) AS occurrenceCount
FROM analytics.snapshots
WHERE 
  family_id IN (7901,4334,7905,7908,7911,4345,4298477,7916)
GROUP BY 
  snapshot,
  kingdom,
  phylum,
  class_rank,
  order_rank,
  family,
  genus,
  scientific_name,
  country,
  latitude,
  longitude,
  year,
  CASE basis_of_record 
    WHEN 'MACHINE_OBSERVATION' THEN 'OBSERVATION' 
    WHEN 'HUMAN_OBSERVATION' THEN 'OBSERVATION' 
    ELSE basis_of_record
  END,
  publisher_id,
  publisher_country;
  

---
-- Location of occurrences per species per year for the species within the invasive list.
---
CREATE TABLE sweden.query5
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
AS SELECT
  snapshot,
  kingdom,
  phylum,
  class_rank,
  order_rank,
  family,
  genus,
  scientific_name,
  country,
  latitude,
  longitude,
  year,
  CASE basis_of_record 
    WHEN 'MACHINE_OBSERVATION' THEN 'OBSERVATION' 
    WHEN 'HUMAN_OBSERVATION' THEN 'OBSERVATION' 
    ELSE basis_of_record
  END as basis_of_record,  
  COUNT(*) AS occurrenceCount
FROM sweden.invasives_snapshot
GROUP BY 
  snapshot,
  kingdom,
  phylum,
  class_rank,
  order_rank,
  family,
  genus,
  scientific_name,
  country,
  latitude,
  longitude,
  year,
  CASE basis_of_record 
    WHEN 'MACHINE_OBSERVATION' THEN 'OBSERVATION' 
    WHEN 'HUMAN_OBSERVATION' THEN 'OBSERVATION' 
    ELSE basis_of_record
  END;


