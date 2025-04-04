DROP TABLE IF EXISTS occ_country_cell_one_deg;
CREATE TABLE occ_country_cell_one_deg
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  t1.country,
  CAST(SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS varchar) AS one_cell,
  CAST(SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS varchar) AS under_twenty_cells,
  CAST(SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS varchar) AS under_hundred_cells,
  CAST(SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS varchar) AS under_thousand_cells,
  CAST(SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS varchar) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    country,
    species_id,
    COUNT(DISTINCT
      CONCAT(
        CAST(floor(latitude) AS varchar),
        ',',
        CAST(floor(longitude) AS varchar)
      )
    ) AS num_cells
  FROM
    snapshots
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

-- occ_publisherCountry_cell_one_deg
DROP TABLE IF EXISTS occ_publisherCountry_cell_one_deg;
CREATE TABLE occ_publisherCountry_cell_one_deg
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  t1.publisher_country,
  CAST( SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS varchar ) AS one_cell,
  CAST( SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS varchar ) AS under_twenty_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS varchar ) AS under_hundred_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS varchar ) AS under_thousand_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS varchar ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    publisher_country,
    species_id,
    COUNT(DISTINCT
      CONCAT(
        CAST(floor(latitude) AS varchar),
        ',',
        CAST(floor(longitude) AS varchar)
      )
    ) AS num_cells
  FROM
    snapshots
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


-- occ_gbifRegion_cell_one_deg
DROP TABLE IF EXISTS occ_gbifRegion_cell_one_deg;
CREATE TABLE occ_gbifRegion_cell_one_deg
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  t1.gbif_region,
  CAST( SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS varchar ) AS one_cell,
  CAST( SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS varchar ) AS under_twenty_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS varchar ) AS under_hundred_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS varchar ) AS under_thousand_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS varchar ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    gbif_region,
    species_id,
    COUNT(DISTINCT
      CONCAT(
        CAST(floor(latitude) AS varchar),
        ',',
        CAST(floor(longitude) AS varchar)
      )
    ) AS num_cells
  FROM
    snapshots
  WHERE
    species_id IS NOT NULL AND
    year IS NOT NULL AND year>1970 AND
    latitude IS NOT NULL AND longitude IS NOT NULL AND gbif_region IS NOT NULL
  GROUP BY
    snapshot,
    gbif_region,
    species_id) t1
GROUP BY
  t1.snapshot,
  t1.gbif_region;

-- occ_publisherGbifRegion_cell_one_deg
DROP TABLE IF EXISTS occ_publisherGbifRegion_cell_one_deg;
CREATE TABLE occ_publisherGbifRegion_cell_one_deg
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  t1.publisher_gbif_region,
  CAST(SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS varchar) AS one_cell,
  CAST( SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS varchar ) AS under_twenty_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS varchar ) AS under_hundred_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS varchar ) AS under_thousand_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS varchar ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    publisher_gbif_region,
    species_id,
    COUNT(DISTINCT
      CONCAT(
        CAST(floor(latitude) AS varchar),
        ',',
        CAST(floor(longitude) AS varchar)
      )
    ) AS num_cells
  FROM
    snapshots
  WHERE
    species_id IS NOT NULL AND
    year IS NOT NULL AND year>1970 AND
    latitude IS NOT NULL AND longitude IS NOT NULL AND publisher_gbif_region IS NOT NULL
  GROUP BY
    snapshot,
    publisher_gbif_region,
    species_id) t1
GROUP BY
  t1.snapshot,
  t1.publisher_gbif_region;

-- occ_cell_one_deg
DROP TABLE IF EXISTS occ_cell_one_deg;
CREATE TABLE occ_cell_one_deg
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  CAST(SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS varchar) AS one_cell,
  CAST( SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS varchar ) AS under_twenty_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS varchar ) AS under_hundred_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS varchar ) AS under_thousand_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS varchar ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    species_id,
    COUNT(DISTINCT
      CONCAT(
        CAST(floor(latitude) AS varchar),
        ',',
        CAST(floor(longitude) AS varchar)
      )
    ) AS num_cells
  FROM
    snapshots
  WHERE
    species_id IS NOT NULL AND
    year IS NOT NULL AND year>1970 AND
    latitude IS NOT NULL AND longitude IS NOT NULL
  GROUP BY
    snapshot,
    species_id) t1
GROUP BY
  t1.snapshot;

-- occ_country_cell_point_one_deg
DROP TABLE IF EXISTS occ_country_cell_point_one_deg;
CREATE TABLE occ_country_cell_point_one_deg
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  t1.country,
  CAST(SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS varchar) AS one_cell,
  CAST( SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS varchar ) AS under_twenty_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS varchar ) AS under_hundred_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS varchar ) AS under_thousand_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS varchar ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    country,
    species_id,
    COUNT(DISTINCT
      CONCAT(
        CAST(floor(10*latitude) AS varchar),
        ',',
        CAST(floor(10*longitude) AS varchar)
      )
    ) AS num_cells
  FROM
    snapshots
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

-- occ_publisherCountry_cell_point_one_deg
DROP TABLE IF EXISTS occ_publisherCountry_cell_point_one_deg;
CREATE TABLE occ_publisherCountry_cell_point_one_deg
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  t1.publisher_country,
  CAST(SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS varchar) AS one_cell,
  CAST( SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS varchar ) AS under_twenty_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS varchar ) AS under_hundred_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS varchar ) AS under_thousand_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS varchar ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    publisher_country,
    species_id,
    COUNT(DISTINCT
      CONCAT(
        CAST(floor(10*latitude) AS varchar),
        ',',
        CAST(floor(10*longitude) AS varchar)
      )
    ) AS num_cells
  FROM
    snapshots
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

-- occ_gbifRegion_cell_point_one_deg
DROP TABLE IF EXISTS occ_gbifRegion_cell_point_one_deg;
CREATE TABLE occ_gbifRegion_cell_point_one_deg
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  t1.gbif_region,
  CAST(SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS varchar) AS one_cell,
  CAST( SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS varchar ) AS under_twenty_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS varchar ) AS under_hundred_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS varchar ) AS under_thousand_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS varchar ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    gbif_region,
    species_id,
    COUNT(DISTINCT
      CONCAT(
        CAST(floor(10*latitude) AS varchar),
        ',',
        CAST(floor(10*longitude) AS varchar)
      )
    ) AS num_cells
  FROM
    snapshots
  WHERE
    species_id IS NOT NULL AND
    year IS NOT NULL AND year>1970 AND
    latitude IS NOT NULL AND longitude IS NOT NULL AND gbif_region IS NOT NULL
  GROUP BY
    snapshot,
    gbif_region,
    species_id) t1
GROUP BY
  t1.snapshot,
  t1.gbif_region;

-- occ_publisherGbifRegion_cell_point_one_deg
DROP TABLE IF EXISTS occ_publisherGbifRegion_cell_point_one_deg;
CREATE TABLE occ_publisherGbifRegion_cell_point_one_deg
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  t1.publisher_gbif_region,
  CAST(SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS varchar) AS one_cell,
  CAST( SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS varchar ) AS under_twenty_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS varchar ) AS under_hundred_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS varchar ) AS under_thousand_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS varchar ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    publisher_gbif_region,
    species_id,
    COUNT(DISTINCT
      CONCAT(
        CAST(floor(10*latitude) AS varchar),
        ',',
        CAST(floor(10*longitude) AS varchar)
      )
    ) AS num_cells
  FROM
    snapshots
  WHERE
    species_id IS NOT NULL AND
    year IS NOT NULL AND year>1970 AND
    latitude IS NOT NULL AND longitude IS NOT NULL AND publisher_gbif_region IS NOT NULL
  GROUP BY
    snapshot,
    publisher_gbif_region,
    species_id) t1
GROUP BY
  t1.snapshot,
  t1.publisher_gbif_region;

-- occ_cell_point_one_deg
DROP TABLE IF EXISTS occ_cell_point_one_deg;
CREATE TABLE occ_cell_point_one_deg
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  CAST(SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS varchar) AS one_cell,
  CAST( SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS varchar ) AS under_twenty_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS varchar ) AS under_hundred_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS varchar ) AS under_thousand_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS varchar ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    species_id,
    COUNT(DISTINCT
      CONCAT(
        CAST(floor(10*latitude) AS varchar),
        ',',
        CAST(floor(10*longitude) AS varchar)
      )
    ) AS num_cells
  FROM
    snapshots
  WHERE
    species_id IS NOT NULL AND
    year IS NOT NULL AND year>1970 AND
    latitude IS NOT NULL AND longitude IS NOT NULL
  GROUP BY
    snapshot,
    species_id) t1
GROUP BY
  t1.snapshot;

-- occ_country_cell_half_deg
DROP TABLE IF EXISTS occ_country_cell_half_deg;
CREATE TABLE occ_country_cell_half_deg
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  t1.country,
  CAST(SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS varchar) AS one_cell,
  CAST( SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS varchar ) AS under_twenty_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS varchar ) AS under_hundred_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS varchar ) AS under_thousand_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS varchar ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    country,
    species_id,
    COUNT(DISTINCT
      CONCAT(
        CAST(floor(2*latitude) AS varchar),
        ',',
        CAST(floor(2*longitude) AS varchar)
      )
    ) AS num_cells
  FROM
    snapshots
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

-- occ_publisherCountry_cell_half_deg
DROP TABLE IF EXISTS occ_publisherCountry_cell_half_deg;
CREATE TABLE occ_publisherCountry_cell_half_deg
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  t1.publisher_country,
  CAST(SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS varchar) AS one_cell,
  CAST( SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS varchar ) AS under_twenty_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS varchar ) AS under_hundred_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS varchar ) AS under_thousand_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS varchar ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    publisher_country,
    species_id,
    COUNT(DISTINCT
      CONCAT(
        CAST(floor(2*latitude) AS varchar),
        ',',
        CAST(floor(2*longitude) AS varchar)
      )
    ) AS num_cells
  FROM
    snapshots
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

-- occ_gbifRegion_cell_half_deg
DROP TABLE IF EXISTS occ_gbifRegion_cell_half_deg;
CREATE TABLE occ_gbifRegion_cell_half_deg
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  t1.gbif_region,
  CAST(SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS varchar) AS one_cell,
  CAST( SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS varchar ) AS under_twenty_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS varchar ) AS under_hundred_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS varchar ) AS under_thousand_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS varchar ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    gbif_region,
    species_id,
    COUNT(DISTINCT
      CONCAT(
        CAST(floor(2*latitude) AS varchar),
        ',',
        CAST(floor(2*longitude) AS varchar)
      )
    ) AS num_cells
  FROM
    snapshots
  WHERE
    species_id IS NOT NULL AND
    year IS NOT NULL AND year>1970 AND
    latitude IS NOT NULL AND longitude IS NOT NULL AND gbif_region IS NOT NULL
  GROUP BY
    snapshot,
    gbif_region,
    species_id) t1
GROUP BY
  t1.snapshot,
  t1.gbif_region;

-- occ_publisherGbifRegion_cell_half_deg
DROP TABLE IF EXISTS occ_publisherGbifRegion_cell_half_deg;
CREATE TABLE occ_publisherGbifRegion_cell_half_deg
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  t1.publisher_gbif_region,
  CAST(SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS varchar) AS one_cell,
  CAST( SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS varchar ) AS under_twenty_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS varchar ) AS under_hundred_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS varchar ) AS under_thousand_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS varchar ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    publisher_gbif_region,
    species_id,
    COUNT(DISTINCT
      CONCAT(
        CAST(floor(2*latitude) AS varchar),
        ',',
        CAST(floor(2*longitude) AS varchar)
      )
    ) AS num_cells
  FROM
    snapshots
  WHERE
    species_id IS NOT NULL AND
    year IS NOT NULL AND year>1970 AND
    latitude IS NOT NULL AND longitude IS NOT NULL AND publisher_gbif_region IS NOT NULL
  GROUP BY
    snapshot,
    publisher_gbif_region,
    species_id) t1
GROUP BY
  t1.snapshot,
  t1.publisher_gbif_region;

-- occ_cell_half_deg
DROP TABLE IF EXISTS occ_cell_half_deg;
CREATE TABLE occ_cell_half_deg
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  CAST(SUM( CASE WHEN t1.num_cells=1 THEN 1 ELSE 0 END ) AS varchar) AS one_cell,
  CAST( SUM( CASE WHEN t1.num_cells>1 AND num_cells<=19 THEN 1 ELSE 0 END ) AS varchar ) AS under_twenty_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=20 AND num_cells<=99 THEN 1 ELSE 0 END ) AS varchar ) AS under_hundred_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=100 AND num_cells<=999 THEN 1 ELSE 0 END ) AS varchar ) AS under_thousand_cells,
  CAST( SUM( CASE WHEN t1.num_cells>=1000 THEN 1 ELSE 0 END ) AS varchar ) AS over_thousand_cells
FROM
  (SELECT
    snapshot,
    species_id,
    COUNT(DISTINCT
      CONCAT(
        CAST(floor(2*latitude) AS varchar),
        ',',
        CAST(floor(2*longitude) AS varchar)
      )
    ) AS num_cells
  FROM
    snapshots
  WHERE
    species_id IS NOT NULL AND
    year IS NOT NULL AND year>1970 AND
    latitude IS NOT NULL AND longitude IS NOT NULL
  GROUP BY
    snapshot,
    species_id) t1
GROUP BY
  t1.snapshot;
