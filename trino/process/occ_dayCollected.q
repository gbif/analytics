-- occ_country_dayCollected
DROP TABLE IF EXISTS occ_country_dayCollected;
CREATE TABLE occ_country_dayCollected
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  country,
  CAST(date_diff(
    'day',
    date(concat_ws('-', CAST(year AS varchar), '01', '01')),
    date(concat_ws('-', CAST(year AS varchar), CAST(month AS varchar), CAST(day AS varchar)))
    ) + 1 AS varchar) as day_of_year,
  CAST(COUNT(*) AS varchar) AS count
FROM snapshots
WHERE
  day IS NOT NULL AND
  month IS NOT NULL AND
  year IS NOT NULL
GROUP BY snapshot,country,
date_diff('day',
    date(concat_ws('-', CAST(year AS varchar), '01', '01')),
    date(concat_ws('-', CAST(year AS varchar), CAST(month AS varchar), CAST(day AS varchar)))
  ) + 1;

-- occ_publisherCountry_dayCollected
DROP TABLE IF EXISTS occ_publisherCountry_dayCollected;
CREATE TABLE occ_publisherCountry_dayCollected
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) AS snapshot,
  publisher_country,
  CAST(date_diff(
    'day',
    date(concat_ws('-', CAST(year AS varchar), '01', '01')),
    date(concat_ws('-', CAST(year AS varchar), CAST(month AS varchar), CAST(day AS varchar)))
  ) + 1 as varchar) as day_of_year,
  CAST(COUNT(*) AS varchar) AS count
FROM snapshots
WHERE
  day IS NOT NULL AND
  month IS NOT NULL AND
  year IS NOT NULL
GROUP BY snapshot,publisher_country,
date_diff(
    'day',
    date(concat_ws('-', CAST(year AS varchar), '01', '01')),
    date(concat_ws('-', CAST(year AS varchar), CAST(month AS varchar), CAST(day AS varchar)))
  ) + 1;

-- occ_gbifRegion_dayCollected
DROP TABLE IF EXISTS occ_gbifRegion_dayCollected;
CREATE TABLE occ_gbifRegion_dayCollected
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) AS snapshot,
  gbif_region,
  CAST(date_diff('day',
  date(concat_ws('-', CAST(year AS varchar), '01', '01')),
    date(concat_ws('-', CAST(year AS varchar), CAST(month AS varchar), CAST(day AS varchar)))
  ) + 1 as varchar) as day_of_year,
  CAST(COUNT(*) AS varchar) AS count
FROM snapshots
WHERE
  day IS NOT NULL AND
  month IS NOT NULL AND
  year IS NOT NULL
GROUP BY snapshot,gbif_region,
date_diff('day',
    date(concat_ws('-', CAST(year AS varchar), '01', '01')),
    date(concat_ws('-', CAST(year AS varchar), CAST(month AS varchar), CAST(day AS varchar)))
  ) + 1;

-- occ_publisherGbifRegion_dayCollected
DROP TABLE IF EXISTS occ_publisherGbifRegion_dayCollected;
CREATE TABLE occ_publisherGbifRegion_dayCollected
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) AS snapshot,
  publisher_gbif_region,
  CAST(date_diff('day',
    date(concat_ws('-', CAST(year AS varchar), '01', '01')),
    date(concat_ws('-', CAST(year AS varchar), CAST(month AS varchar), CAST(day AS varchar)))
  ) + 1 as varchar) as day_of_year,
  CAST(COUNT(*) AS varchar) AS count
FROM snapshots
WHERE
  day IS NOT NULL AND
  month IS NOT NULL AND
  year IS NOT NULL
GROUP BY snapshot,publisher_gbif_region,
date_diff('day',
    date(concat_ws('-', CAST(year AS varchar), '01', '01')),
    date(concat_ws('-', CAST(year AS varchar), CAST(month AS varchar), CAST(day AS varchar)))
  ) + 1;

-- occ_dayCollected
DROP TABLE IF EXISTS occ_dayCollected;
CREATE TABLE occ_dayCollected
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) AS snapshot,
  day_of_year,
  CAST(SUM(CAST(count as bigint)) as varchar) AS count
FROM occ_country_dayCollected
GROUP BY snapshot,day_of_year;
