-- occ_country
DROP TABLE IF EXISTS occ_country;
CREATE TABLE occ_country (
  snapshot VARCHAR,
  country VARCHAR,
  total_occurrences VARCHAR
) WITH (format = 'CSV');

-- occ_publisherCountry
DROP TABLE IF EXISTS occ_publisherCountry;
CREATE TABLE occ_publisherCountry  (
  snapshot VARCHAR,
  publisher_country VARCHAR,
  total_occurrences VARCHAR
) WITH (format = 'CSV');

-- occ_gbifRegion
DROP TABLE IF EXISTS occ_gbifRegion;
CREATE TABLE occ_gbifRegion (
  snapshot VARCHAR,
  gbif_region VARCHAR,
  total_occurrences VARCHAR
) WITH (format = 'CSV');

-- occ_publisherGbifRegion
DROP TABLE IF EXISTS occ_publisherGbifRegion;
CREATE TABLE occ_publisherGbifRegion  (
  snapshot VARCHAR,
  publisher_gbif_region VARCHAR,
  total_occurrences VARCHAR
) WITH (format = 'CSV');

-- occ
DROP TABLE IF EXISTS occ;
CREATE TABLE occ  (
  snapshot VARCHAR,
  total_occurrences VARCHAR
) WITH (format = 'CSV');


INSERT INTO occ_country
  SELECT
    CAST(snapshot AS varchar) as snapshot,
    country,
    CAST(COUNT(*) AS VARCHAR) AS total_occurrences
  FROM snapshots
  GROUP BY snapshot, country;


INSERT INTO occ_publisherCountry
  SELECT
    CAST(snapshot AS varchar) as snapshot,
    publisher_country,
    CAST(COUNT(*) AS VARCHAR) AS total_occurrences
  FROM snapshots
  GROUP BY snapshot, publisher_country;


INSERT INTO occ_gbifRegion
  SELECT
    CAST(snapshot AS varchar) as snapshot,
    gbif_region,
    CAST(COUNT(*) AS VARCHAR) AS total_occurrences
  FROM snapshots
  GROUP BY snapshot, gbif_region;


INSERT INTO occ_publisherGbifRegion
  SELECT
    CAST(snapshot AS varchar) as snapshot,
    publisher_gbif_region,
    CAST(COUNT(*) AS VARCHAR) AS total_occurrences
  FROM snapshots
  GROUP BY snapshot, publisher_gbif_region;


INSERT INTO occ
  SELECT
    CAST(snapshot AS varchar) as snapshot,
    CAST(COUNT(*) AS VARCHAR) AS total_occurrences
  FROM snapshots
  GROUP BY snapshot;

-- spe_country
DROP TABLE IF EXISTS spe_country;
CREATE TABLE spe_country
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  t1.country As country,
  CAST(COUNT (DISTINCT species_id) AS VARCHAR) AS total_species
FROM (SELECT
    snapshot,
    country,
    species_id
   FROM snapshots
   WHERE species_id IS NOT NULL
  ) t1
GROUP BY t1.snapshot, t1.country;

-- spe_publisherCountry
DROP TABLE IF EXISTS spe_publisherCountry;
CREATE TABLE spe_publisherCountry
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  t1.publisher_country As publisher_country,
  CAST(COUNT (DISTINCT species_id) AS VARCHAR) AS total_species
FROM (SELECT
    snapshot,
    publisher_country,
    species_id
   FROM snapshots
   WHERE species_id IS NOT NULL
  ) t1
GROUP BY t1.snapshot, t1.publisher_country;

-- spe_gbifRegion
DROP TABLE IF EXISTS spe_gbifRegion;
CREATE TABLE spe_gbifRegion
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  t1.gbif_region As gbif_region,
  CAST(COUNT (DISTINCT species_id) AS VARCHAR) AS total_species
FROM (SELECT
    snapshot,
    gbif_region,
    species_id
   FROM snapshots
   WHERE species_id IS NOT NULL
  ) t1
GROUP BY t1.snapshot, t1.gbif_region;

-- spe_publisherGbifRegion
DROP TABLE IF EXISTS spe_publisherGbifRegion;
CREATE TABLE spe_publisherGbifRegion
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  t1.publisher_gbif_region As publisher_gbif_region,
  CAST(COUNT (DISTINCT species_id) AS VARCHAR) AS total_species
FROM (SELECT
    snapshot,
    publisher_gbif_region,
    species_id
   FROM snapshots
   WHERE species_id IS NOT NULL
  ) t1
GROUP BY t1.snapshot, t1.publisher_gbif_region;

-- spe
DROP TABLE IF EXISTS spe;
CREATE TABLE spe
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  CAST(COUNT (DISTINCT species_id) AS VARCHAR) AS total_species
FROM (SELECT
    snapshot,
    species_id
   FROM snapshots
   WHERE species_id IS NOT NULL
  ) t1
GROUP BY t1.snapshot;
