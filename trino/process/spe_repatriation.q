-- spe_country_repatriation
DROP TABLE IF EXISTS spe_country_repatriation;
CREATE TABLE spe_country_repatriation
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  t1.country As country,
  CAST(COUNT (DISTINCT national_species_id) AS VARCHAR) AS national,
  CAST(COUNT (DISTINCT international_species_id) AS VARCHAR) AS international
FROM (SELECT
    snapshot,
    country,
    CASE WHEN country=publisher_country THEN species_id ELSE NULL END AS national_species_id,
    CASE WHEN country!=publisher_country THEN species_id ELSE NULL END AS international_species_id
   FROM snapshots
   WHERE country IS NOT NULL AND publisher_country IS NOT NULL AND species_id IS NOT NULL
  ) t1
GROUP BY t1.snapshot,t1.country;

-- spe_publisherCountry_repatriation
DROP TABLE IF EXISTS spe_publisherCountry_repatriation;
CREATE TABLE spe_publisherCountry_repatriation
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  t1.publisher_country As publisher_country,
  CAST(COUNT (DISTINCT national_species_id) AS VARCHAR) AS national,
  CAST(COUNT (DISTINCT international_species_id) AS VARCHAR) AS international
FROM (SELECT
    snapshot,
    publisher_country,
    CASE WHEN country=publisher_country THEN species_id ELSE NULL END AS national_species_id,
    CASE WHEN country!=publisher_country THEN species_id ELSE NULL END AS international_species_id
   FROM snapshots
   WHERE country IS NOT NULL AND publisher_country IS NOT NULL AND species_id IS NOT NULL
  ) t1
GROUP BY t1.snapshot,t1.publisher_country;

-- spe_gbifRegion_repatriation
DROP TABLE IF EXISTS spe_gbifRegion_repatriation;
CREATE TABLE spe_gbifRegion_repatriation
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  t1.gbif_region As gbif_region,
  CAST(COUNT (DISTINCT national_species_id) AS VARCHAR) AS national,
  CAST(COUNT (DISTINCT international_species_id) AS VARCHAR) AS international
FROM (SELECT
    snapshot,
    gbif_region,
    CASE WHEN country=publisher_country THEN species_id ELSE NULL END AS national_species_id,
    CASE WHEN country!=publisher_country THEN species_id ELSE NULL END AS international_species_id
   FROM snapshots
   WHERE country IS NOT NULL AND publisher_country IS NOT NULL AND species_id IS NOT NULL
  ) t1
GROUP BY t1.snapshot,t1.gbif_region;

-- spe_publisherGbifRegion_repatriation
DROP TABLE IF EXISTS spe_publisherGbifRegion_repatriation;
CREATE TABLE spe_publisherGbifRegion_repatriation
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  t1.publisher_gbif_region As publisher_gbif_region,
  CAST(COUNT (DISTINCT national_species_id) AS VARCHAR) AS national,
  CAST(COUNT (DISTINCT international_species_id) AS VARCHAR) AS international
FROM (SELECT
    snapshot,
    publisher_gbif_region,
    CASE WHEN country=publisher_country THEN species_id ELSE NULL END AS national_species_id,
    CASE WHEN country!=publisher_country THEN species_id ELSE NULL END AS international_species_id
   FROM snapshots
   WHERE country IS NOT NULL AND publisher_country IS NOT NULL AND species_id IS NOT NULL
  ) t1
GROUP BY t1.snapshot,t1.publisher_gbif_region;

-- spe_repatriation
DROP TABLE IF EXISTS spe_repatriation;
CREATE TABLE spe_repatriation
WITH (format = 'CSV')
AS SELECT
  CAST(t1.snapshot AS varchar) as snapshot,
  CAST(COUNT (DISTINCT national_species_id) AS VARCHAR) AS national,
  CAST(COUNT (DISTINCT international_species_id) AS VARCHAR) AS international
FROM (SELECT
    snapshot,
    CASE WHEN country=publisher_country THEN species_id ELSE NULL END AS national_species_id,
    CASE WHEN country!=publisher_country THEN species_id ELSE NULL END AS international_species_id
   FROM snapshots
   WHERE country IS NOT NULL AND publisher_country IS NOT NULL AND species_id IS NOT NULL
  ) t1
GROUP BY t1.snapshot;
