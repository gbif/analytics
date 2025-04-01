-- occ_country_repatriation
DROP TABLE IF EXISTS occ_country_repatriation;
CREATE TABLE occ_country_repatriation
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  country,
  CAST(SUM(CASE WHEN country=publisher_country THEN 1 ELSE 0 END) AS varchar) AS national,
  CAST(SUM(CASE WHEN country!=publisher_country THEN 1 ELSE 0 END) AS varchar) AS international
FROM snapshots
WHERE country IS NOT NULL AND publisher_country IS NOT NULL
GROUP BY snapshot,country;

-- occ_publisherCountry_repatriation
DROP TABLE IF EXISTS occ_publisherCountry_repatriation;
CREATE TABLE occ_publisherCountry_repatriation
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  publisher_country,
  CAST(SUM(CASE WHEN country=publisher_country THEN 1 ELSE 0 END) AS varchar) AS national,
  CAST(SUM(CASE WHEN country!=publisher_country THEN 1 ELSE 0 END) AS varchar) AS international
FROM snapshots
WHERE country IS NOT NULL AND publisher_country IS NOT NULL
GROUP BY snapshot,publisher_country;

-- occ_gbifRegion_repatriation
DROP TABLE IF EXISTS occ_gbifRegion_repatriation;
CREATE TABLE occ_gbifRegion_repatriation
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  gbif_region,
  CAST(SUM(CASE WHEN country=publisher_country THEN 1 ELSE 0 END) AS varchar) AS national,
  CAST(SUM(CASE WHEN country!=publisher_country THEN 1 ELSE 0 END) AS varchar) AS international
FROM snapshots
WHERE gbif_region IS NOT NULL AND publisher_gbif_region IS NOT NULL
GROUP BY snapshot,gbif_region;

-- occ_publisherGbifRegion_repatriation
DROP TABLE IF EXISTS occ_publisherGbifRegion_repatriation;
CREATE TABLE occ_publisherGbifRegion_repatriation
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  publisher_gbif_region,
  CAST(SUM(CASE WHEN country=publisher_country THEN 1 ELSE 0 END) AS varchar) AS national,
  CAST(SUM(CASE WHEN country!=publisher_country THEN 1 ELSE 0 END) AS varchar) AS international
FROM snapshots
WHERE gbif_region IS NOT NULL AND publisher_gbif_region IS NOT NULL
GROUP BY snapshot,publisher_gbif_region;

-- occ_repatriation
DROP TABLE IF EXISTS occ_repatriation;
CREATE TABLE occ_repatriation
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  CAST(SUM(CASE WHEN country=publisher_country THEN 1 ELSE 0 END) AS varchar) AS national,
  CAST(SUM(CASE WHEN country!=publisher_country THEN 1 ELSE 0 END) AS varchar) AS international
FROM snapshots
WHERE country IS NOT NULL AND publisher_country IS NOT NULL
GROUP BY snapshot;
