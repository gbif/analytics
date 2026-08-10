-- spe_country_kingdom
DROP TABLE IF EXISTS spe_country_kingdom;
CREATE TABLE spe_country_kingdom
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  country,
  CAST(COALESCE(kingdom_id, 'S') AS VARCHAR) AS kingdom_id,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS species_count
FROM snapshots
WHERE species_id IS NOT NULL
GROUP BY
  snapshot,
  country,
  COALESCE(kingdom_id, 'S');

-- spe_publisherCountry_kingdom
DROP TABLE IF EXISTS spe_publisherCountry_kingdom;
CREATE TABLE spe_publisherCountry_kingdom
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  publisher_country,
  CAST(COALESCE(kingdom_id, 'S') AS VARCHAR) AS kingdom_id,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS species_count
FROM snapshots
WHERE species_id IS NOT NULL
GROUP BY
  snapshot,
  publisher_country,
  COALESCE(kingdom_id, 'S');

-- spe_gbifRegion_kingdom
DROP TABLE IF EXISTS spe_gbifRegion_kingdom;
CREATE TABLE spe_gbifRegion_kingdom
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  gbif_region,
  CAST(COALESCE(kingdom_id, 'S') AS VARCHAR) AS kingdom_id,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS species_count
FROM snapshots
WHERE species_id IS NOT NULL
GROUP BY
  snapshot,
  gbif_region,
  COALESCE(kingdom_id, 'S');

-- spe_publisherGbifRegion_kingdom
DROP TABLE IF EXISTS spe_publisherGbifRegion_kingdom;
CREATE TABLE spe_publisherGbifRegion_kingdom
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  publisher_gbif_region,
  CAST(COALESCE(kingdom_id, 'S') AS VARCHAR) AS kingdom_id,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS species_count
FROM snapshots
WHERE species_id IS NOT NULL
GROUP BY
  snapshot,
  publisher_gbif_region,
  COALESCE(kingdom_id, 'S');

-- spe_kingdom
DROP TABLE IF EXISTS spe_kingdom;
CREATE TABLE spe_kingdom
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  CAST(COALESCE(kingdom_id, 'S') AS VARCHAR) AS kingdom_id,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS species_count
FROM snapshots
WHERE species_id IS NOT NULL
GROUP BY
  snapshot,
  COALESCE(kingdom_id, 'S');

-- spe_country_kingdom_observation
DROP TABLE IF EXISTS spe_country_kingdom_observation;
CREATE TABLE spe_country_kingdom_observation
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  country,
  CAST(COALESCE(kingdom_id, 'S') AS VARCHAR) AS kingdom_id,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS species_count
FROM snapshots
WHERE species_id IS NOT NULL AND basis_of_record IN('OBSERVATION', 'HUMAN_OBSERVATION', 'MACHINE_OBSERVATION')
GROUP BY
  snapshot,
  country,
  COALESCE(kingdom_id, 'S');

-- spe_publisherCountry_kingdom_observation
DROP TABLE IF EXISTS spe_publisherCountry_kingdom_observation;
CREATE TABLE spe_publisherCountry_kingdom_observation
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  publisher_country,
  CAST(COALESCE(kingdom_id, 'S') AS VARCHAR) AS kingdom_id,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS species_count
FROM snapshots
WHERE species_id IS NOT NULL AND basis_of_record IN('OBSERVATION', 'HUMAN_OBSERVATION', 'MACHINE_OBSERVATION')
GROUP BY
  snapshot,
  publisher_country,
  COALESCE(kingdom_id, 'S');

-- spe_gbifRegion_kingdom_observation
DROP TABLE IF EXISTS spe_gbifRegion_kingdom_observation;
CREATE TABLE spe_gbifRegion_kingdom_observation
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  gbif_region,
  CAST(COALESCE(kingdom_id, 'S') AS VARCHAR) AS kingdom_id,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS species_count
FROM snapshots
WHERE species_id IS NOT NULL AND basis_of_record IN('OBSERVATION', 'HUMAN_OBSERVATION', 'MACHINE_OBSERVATION')
GROUP BY
  snapshot,
  gbif_region,
  COALESCE(kingdom_id, 'S');

-- spe_publisherGbifRegion_kingdom_observation
DROP TABLE IF EXISTS spe_publisherGbifRegion_kingdom_observation;
CREATE TABLE spe_publisherGbifRegion_kingdom_observation
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  publisher_gbif_region,
  CAST(COALESCE(kingdom_id, 'S') AS VARCHAR) AS kingdom_id,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS species_count
FROM snapshots
WHERE species_id IS NOT NULL AND basis_of_record IN('OBSERVATION', 'HUMAN_OBSERVATION', 'MACHINE_OBSERVATION')
GROUP BY
  snapshot,
  publisher_gbif_region,
  COALESCE(kingdom_id, 'S');

-- spe_kingdom_observation
DROP TABLE IF EXISTS spe_kingdom_observation;
CREATE TABLE spe_kingdom_observation
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  CAST(COALESCE(kingdom_id, 'S') AS VARCHAR) AS kingdom_id,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS species_count
FROM snapshots
WHERE species_id IS NOT NULL AND basis_of_record IN('OBSERVATION', 'HUMAN_OBSERVATION', 'MACHINE_OBSERVATION')
GROUP BY
  snapshot,
  COALESCE(kingdom_id, 'S');

-- spe_country_kingdom_specimen
DROP TABLE IF EXISTS spe_country_kingdom_specimen;
CREATE TABLE spe_country_kingdom_specimen
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  country,
  CAST(COALESCE(kingdom_id, 'S') AS VARCHAR) AS kingdom_id,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS species_count
FROM snapshots
WHERE species_id IS NOT NULL AND basis_of_record IN('PRESERVED_SPECIMEN')
GROUP BY
  snapshot,
  country,
  COALESCE(kingdom_id, 'S');

-- spe_publisherCountry_kingdom_specimen
DROP TABLE IF EXISTS spe_publisherCountry_kingdom_specimen;
CREATE TABLE spe_publisherCountry_kingdom_specimen
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  publisher_country,
  CAST(COALESCE(kingdom_id, 'S') AS VARCHAR) AS kingdom_id,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS species_count
FROM snapshots
WHERE species_id IS NOT NULL AND basis_of_record IN('PRESERVED_SPECIMEN')
GROUP BY
  snapshot,
  publisher_country,
  COALESCE(kingdom_id, 'S');

-- spe_gbifRegion_kingdom_specimen
DROP TABLE IF EXISTS spe_gbifRegion_kingdom_specimen;
CREATE TABLE spe_gbifRegion_kingdom_specimen
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  gbif_region,
  CAST(COALESCE(kingdom_id, 'S') AS VARCHAR) AS kingdom_id,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS species_count
FROM snapshots
WHERE species_id IS NOT NULL AND basis_of_record IN('PRESERVED_SPECIMEN')
GROUP BY
  snapshot,
  gbif_region,
  COALESCE(kingdom_id, 'S');

-- spe_publisherGbifRegion_kingdom_specimen
DROP TABLE IF EXISTS spe_publisherGbifRegion_kingdom_specimen;
CREATE TABLE spe_publisherGbifRegion_kingdom_specimen
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  publisher_gbif_region,
  CAST(COALESCE(kingdom_id, 'S') AS VARCHAR) AS kingdom_id,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS species_count
FROM snapshots
WHERE species_id IS NOT NULL AND basis_of_record IN('PRESERVED_SPECIMEN')
GROUP BY
  snapshot,
  publisher_gbif_region,
  COALESCE(kingdom_id, 'S');

-- spe_kingdom_specimen
DROP TABLE IF EXISTS spe_kingdom_specimen;
CREATE TABLE spe_kingdom_specimen
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  CAST(COALESCE(kingdom_id, 'S') AS VARCHAR) AS kingdom_id,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS species_count
FROM snapshots
WHERE species_id IS NOT NULL AND basis_of_record IN('PRESERVED_SPECIMEN')
GROUP BY
  snapshot,
  COALESCE(kingdom_id, 'S');
