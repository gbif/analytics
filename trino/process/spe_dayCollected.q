-- spe_country_dayCollected
DROP TABLE IF EXISTS spe_country_dayCollected;
CREATE TABLE spe_country_dayCollected
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  country,
  CAST(date_diff(
    'day',
    date(concat_ws('-', CAST(year AS VARCHAR), '01', '01')),
    date(concat_ws('-', CAST(year AS VARCHAR), CAST(month AS VARCHAR), CAST(day AS VARCHAR)))
  ) + 1 AS VARCHAR) AS day_of_year,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS count
FROM snapshots
WHERE
  day IS NOT NULL AND
  month IS NOT NULL AND
  year IS NOT NULL AND
  species_id IS NOT NULL
GROUP BY snapshot,country,
date_diff(
    'day',
    date(concat_ws('-', CAST(year AS VARCHAR), '01', '01')),
    date(concat_ws('-', CAST(year AS VARCHAR), CAST(month AS VARCHAR), CAST(day AS VARCHAR)))
  ) + 1;

-- spe_publisherCountry_dayCollected
DROP TABLE IF EXISTS spe_publisherCountry_dayCollected;
CREATE TABLE spe_publisherCountry_dayCollected
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  publisher_country,
  CAST(date_diff(
    'day',
    date(concat_ws('-', CAST(year AS VARCHAR), '01', '01')),
    date(concat_ws('-', CAST(year AS VARCHAR), CAST(month AS VARCHAR), CAST(day AS VARCHAR)))
  ) + 1 AS VARCHAR) as day_of_year,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS count
FROM snapshots
WHERE
  day IS NOT NULL AND
  month IS NOT NULL AND
  year IS NOT NULL AND
  species_id IS NOT NULL
GROUP BY snapshot,publisher_country,
date_diff(
    'day',
    date(concat_ws('-', CAST(year AS VARCHAR), '01', '01')),
    date(concat_ws('-', CAST(year AS VARCHAR), CAST(month AS VARCHAR), CAST(day AS VARCHAR)))
  ) + 1;

-- spe_gbifRegion_dayCollected
DROP TABLE IF EXISTS spe_gbifRegion_dayCollected;
CREATE TABLE spe_gbifRegion_dayCollected
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  gbif_region,
  CAST(date_diff(
    'day',
    date(concat_ws('-', CAST(year AS VARCHAR), '01', '01')),
    date(concat_ws('-', CAST(year AS VARCHAR), CAST(month AS VARCHAR), CAST(day AS VARCHAR)))
  ) + 1 AS VARCHAR) as day_of_year,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS count
FROM snapshots
WHERE
  day IS NOT NULL AND
  month IS NOT NULL AND
  year IS NOT NULL AND
  species_id IS NOT NULL
GROUP BY snapshot,gbif_region,
date_diff(
    'day',
    date(concat_ws('-', CAST(year AS VARCHAR), '01', '01')),
    date(concat_ws('-', CAST(year AS VARCHAR), CAST(month AS VARCHAR), CAST(day AS VARCHAR)))
  ) + 1;

-- spe_publisherGbifRegion_dayCollected
DROP TABLE IF EXISTS spe_publisherGbifRegion_dayCollected;
CREATE TABLE spe_publisherGbifRegion_dayCollected
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  publisher_gbif_region,
  CAST(date_diff(
    'day',
    date(concat_ws('-', CAST(year AS VARCHAR), '01', '01')),
    date(concat_ws('-', CAST(year AS VARCHAR), CAST(month AS VARCHAR), CAST(day AS VARCHAR)))
  ) + 1 AS VARCHAR) as day_of_year,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS count
FROM snapshots
WHERE
  day IS NOT NULL AND
  month IS NOT NULL AND
  year IS NOT NULL AND
  species_id IS NOT NULL
GROUP BY snapshot,publisher_gbif_region,
date_diff(
    'day',
    date(concat_ws('-', CAST(year AS VARCHAR), '01', '01')),
    date(concat_ws('-', CAST(year AS VARCHAR), CAST(month AS VARCHAR), CAST(day AS VARCHAR)))
  ) + 1;

-- spe_dayCollected
DROP TABLE IF EXISTS spe_dayCollected;
CREATE TABLE spe_dayCollected
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  CAST(date_diff(
    'day',
    date(concat_ws('-', CAST(year AS VARCHAR), '01', '01')),
    date(concat_ws('-', CAST(year AS VARCHAR), CAST(month AS VARCHAR), CAST(day AS VARCHAR)))
  ) + 1 AS VARCHAR) as day_of_year,
  CAST(COUNT(DISTINCT species_id) AS VARCHAR) AS count
FROM snapshots
WHERE
  day IS NOT NULL AND
  month IS NOT NULL AND
  year IS NOT NULL AND
  species_id IS NOT NULL
GROUP BY snapshot,
date_diff(
    'day',
    date(concat_ws('-', CAST(year AS VARCHAR), '01', '01')),
    date(concat_ws('-', CAST(year AS VARCHAR), CAST(month AS VARCHAR), CAST(day AS VARCHAR)))
  ) + 1;
