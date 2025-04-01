-- occ_country_yearCollected
DROP TABLE IF EXISTS occ_country_yearCollected;
CREATE TABLE occ_country_yearCollected
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  country,
  CAST(year as varchar) as year,
  CAST(COUNT(*) AS varchar) AS count
FROM snapshots
WHERE year IS NOT NULL
GROUP BY snapshot,country,year;

-- occ_publisherCountry_yearCollected
DROP TABLE IF EXISTS occ_publisherCountry_yearCollected;
CREATE TABLE occ_publisherCountry_yearCollected
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  publisher_country,
  CAST(year as varchar) as year,
  CAST(COUNT(*) AS varchar) AS count
FROM snapshots
WHERE year IS NOT NULL
GROUP BY snapshot,publisher_country,year;

-- occ_gbifRegion_yearCollected
DROP TABLE IF EXISTS occ_gbifRegion_yearCollected;
CREATE TABLE occ_gbifRegion_yearCollected
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  gbif_region,
  CAST(year as varchar) as year,
  CAST(COUNT(*) AS varchar) AS count
FROM snapshots
WHERE year IS NOT NULL
GROUP BY snapshot,gbif_region,year;

-- occ_publisherGbifRegion_yearCollected
DROP TABLE IF EXISTS occ_publisherGbifRegion_yearCollected;
CREATE TABLE occ_publisherGbifRegion_yearCollected
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  publisher_gbif_region,
  CAST(year AS varchar) AS year,
  CAST(COUNT(*) AS varchar) AS count
FROM snapshots
WHERE year IS NOT NULL
GROUP BY snapshot,publisher_gbif_region,year;

-- occ_yearCollected
DROP TABLE IF EXISTS occ_yearCollected;
CREATE TABLE occ_yearCollected
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  CAST(year as varchar) as year,
  CAST(SUM(CAST(count AS bigint)) AS varchar) AS count
FROM occ_country_yearCollected
GROUP BY snapshot,year;
