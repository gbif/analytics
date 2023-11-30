-- spe_country_yearCollected
DROP TABLE IF EXISTS spe_country_yearCollected;
CREATE TABLE spe_country_yearCollected
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  country,
  CAST(year AS VARCHAR) AS year,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS count
FROM snapshots
WHERE year IS NOT NULL AND species_id IS NOT NULL
GROUP BY snapshot,country,year;

-- spe_publisherCountry_yearCollected
DROP TABLE IF EXISTS spe_publisherCountry_yearCollected;
CREATE TABLE spe_publisherCountry_yearCollected
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  publisher_country,
  CAST(year AS VARCHAR) AS year,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS count
FROM snapshots
WHERE year IS NOT NULL AND species_id IS NOT NULL
GROUP BY snapshot,publisher_country,year;

-- spe_gbifRegion_yearCollected
DROP TABLE IF EXISTS spe_gbifRegion_yearCollected;
CREATE TABLE spe_gbifRegion_yearCollected
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  gbif_region,
  CAST(year AS VARCHAR) AS year,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS count
FROM snapshots
WHERE year IS NOT NULL AND species_id IS NOT NULL
GROUP BY snapshot,gbif_region,year;

-- spe_publisherGbifRegion_yearCollected
DROP TABLE IF EXISTS spe_publisherGbifRegion_yearCollected;
CREATE TABLE spe_publisherGbifRegion_yearCollected
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  publisher_gbif_region,
  CAST(year AS VARCHAR) AS year,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS count
FROM snapshots
WHERE year IS NOT NULL AND species_id IS NOT NULL
GROUP BY snapshot,publisher_gbif_region,year;

-- spe_yearCollected
DROP TABLE IF EXISTS spe_yearCollected;
CREATE TABLE spe_yearCollected
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  CAST(year AS VARCHAR) AS year,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS count
FROM snapshots
WHERE year IS NOT NULL AND species_id IS NOT NULL
GROUP BY snapshot,year;
