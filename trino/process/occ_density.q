-- occ_density_country_point_one_deg
DROP TABLE IF EXISTS occ_density_country_point_one_deg;
CREATE TABLE occ_density_country_point_one_deg
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  country,
  CAST(LEAST(FLOOR(10 * latitude) / 10, 89.9) AS varchar) AS latitude,
  CAST(FLOOR(10 * ((longitude + 180) % 360 - 180)) / 10 AS varchar) AS longitude,
  CAST(COUNT(*) AS varchar) AS count
FROM
  snapshots
WHERE
  latitude IS NOT NULL AND longitude IS NOT NULL AND country IS NOT NULL
GROUP BY
  snapshot,
  country,
  LEAST(FLOOR(10 * latitude) / 10, 89.9),
  FLOOR(10 * ((longitude + 180) % 360 - 180)) / 10;

-- occ_density_publisherCountry_point_one_deg
DROP TABLE IF EXISTS occ_density_publisherCountry_point_one_deg;
CREATE TABLE occ_density_publisherCountry_point_one_deg
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  publisher_country,
  CAST(LEAST(FLOOR(10 * latitude) / 10, 89.9) as varchar) AS latitude,
  CAST(FLOOR(10 * ((longitude + 180) % 360 - 180)) / 10 as varchar) AS longitude,
  CAST(COUNT(*) AS varchar) AS count
FROM
  snapshots
WHERE
  latitude IS NOT NULL AND longitude IS NOT NULL AND publisher_country IS NOT NULL
GROUP BY
  snapshot,
  publisher_country,
  LEAST(FLOOR(10 * latitude) / 10, 89.9),
  FLOOR(10 * ((longitude + 180) % 360 - 180)) / 10;

-- occ_density_gbifRegion_point_one_deg
DROP TABLE IF EXISTS occ_density_gbifRegion_point_one_deg;
CREATE TABLE occ_density_gbifRegion_point_one_deg
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  gbif_region,
  CAST(LEAST(FLOOR(10 * latitude) / 10, 89.9) as varchar) AS latitude,
  CAST(FLOOR(10 * ((longitude + 180) % 360 - 180)) / 10 as varchar) AS longitude,
  CAST(COUNT(*) AS varchar) AS count
FROM
  snapshots
WHERE
  latitude IS NOT NULL AND longitude IS NOT NULL AND gbif_region IS NOT NULL
GROUP BY
  snapshot,
  gbif_region,
  LEAST(FLOOR(10 * latitude) / 10, 89.9),
  FLOOR(10 * ((longitude + 180) % 360 - 180)) / 10;

-- occ_density_publisherGbifRegion_point_one_deg
DROP TABLE IF EXISTS occ_density_publisherGbifRegion_point_one_deg;
CREATE TABLE occ_density_publisherGbifRegion_point_one_deg
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  publisher_gbif_region,
  CAST(LEAST(FLOOR(10 * latitude) / 10, 89.9) as varchar) AS latitude,
  CAST(FLOOR(10 * ((longitude + 180) % 360 - 180)) / 10 as varchar) AS longitude,
  CAST(COUNT(*) AS varchar) AS count
FROM
  snapshots
WHERE
  latitude IS NOT NULL AND longitude IS NOT NULL AND publisher_gbif_region IS NOT NULL
GROUP BY
  snapshot,
  publisher_gbif_region,
  LEAST(FLOOR(10 * latitude) / 10, 89.9),
  FLOOR(10 * ((longitude + 180) % 360 - 180)) / 10;

-- occ_density_point_one_deg
DROP TABLE IF EXISTS occ_density_point_one_deg;
CREATE TABLE occ_density_point_one_deg
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) as snapshot,
  CAST(LEAST(FLOOR(10 * latitude) / 10, 89.9) as varchar) AS latitude,
  CAST(FLOOR(10 * ((longitude + 180) % 360 - 180)) / 10 as varchar) AS longitude,
  CAST(COUNT(*) AS varchar) AS count
FROM
  snapshots
WHERE
  latitude IS NOT NULL AND longitude IS NOT NULL
GROUP BY
  snapshot,
  LEAST(FLOOR(10 * latitude) / 10, 89.9),
  FLOOR(10 * ((longitude + 180) % 360 - 180)) / 10;
