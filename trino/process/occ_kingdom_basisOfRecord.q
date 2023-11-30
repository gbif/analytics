-- occ_country_kingdom_basisOfRecord
DROP TABLE IF EXISTS occ_country_kingdom_basisOfRecord;
CREATE TABLE occ_country_kingdom_basisOfRecord (
  snapshot VARCHAR,
  country VARCHAR,
  kingdom_id VARCHAR,
  basis_of_record VARCHAR,
  occurrence_count VARCHAR
) WITH (format = 'CSV');

-- occ_publisherCountry_kingdom_basisOfRecord
DROP TABLE IF EXISTS occ_publisherCountry_kingdom_basisOfRecord;
CREATE TABLE occ_publisherCountry_kingdom_basisOfRecord  (
  snapshot VARCHAR,
  publisher_country VARCHAR,
  kingdom_id VARCHAR,
  basis_of_record VARCHAR,
  occurrence_count VARCHAR
) WITH (format = 'CSV');

-- occ_gbifRegion_kingdom_basisOfRecord
DROP TABLE IF EXISTS occ_gbifRegion_kingdom_basisOfRecord;
CREATE TABLE occ_gbifRegion_kingdom_basisOfRecord (
  snapshot VARCHAR,
  gbif_region VARCHAR,
  kingdom_id VARCHAR,
  basis_of_record VARCHAR,
  occurrence_count VARCHAR
) WITH (format = 'CSV');

-- occ_publisherGbifRegion_kingdom_basisOfRecord
DROP TABLE IF EXISTS occ_publisherGbifRegion_kingdom_basisOfRecord;
CREATE TABLE occ_publisherGbifRegion_kingdom_basisOfRecord  (
  snapshot VARCHAR,
  publisher_gbif_region VARCHAR,
  kingdom_id VARCHAR,
  basis_of_record VARCHAR,
  occurrence_count VARCHAR
) WITH (format = 'CSV');

INSERT INTO occ_country_kingdom_basisOfRecord
  SELECT
    snapshot,
    country,
    CAST(COALESCE(kingdom_id, 0) AS VARCHAR) AS kingdom_id,
    COALESCE(basis_of_record, 'UNKNOWN') AS basis_of_record,
    CAST(COUNT(*) AS VARCHAR) AS occurrence_count
  FROM snapshots
  GROUP BY
    snapshot,
    country,
    COALESCE(kingdom_id, 0),
    COALESCE(basis_of_record, 'UNKNOWN');


INSERT INTO occ_publisherCountry_kingdom_basisOfRecord
  SELECT
    snapshot,
    publisher_country,
    CAST(COALESCE(kingdom_id, 0) AS VARCHAR) AS kingdom_id,
    COALESCE(basis_of_record, 'UNKNOWN') AS basis_of_record,
    CAST(COUNT(*) AS VARCHAR) AS occurrence_count
  FROM snapshots
  GROUP BY
    snapshot,
    publisher_country,
    COALESCE(kingdom_id, 0),
    COALESCE(basis_of_record, 'UNKNOWN');


INSERT INTO occ_gbifRegion_kingdom_basisOfRecord
  SELECT
    snapshot,
    gbif_region,
    CAST(COALESCE(kingdom_id, 0) AS VARCHAR) AS kingdom_id,
    COALESCE(basis_of_record, 'UNKNOWN') AS basis_of_record,
    CAST(COUNT(*) AS VARCHAR) AS occurrence_count
  FROM snapshots
  GROUP BY
    snapshot,
    gbif_region,
    COALESCE(kingdom_id, 0),
    COALESCE(basis_of_record, 'UNKNOWN');


INSERT INTO occ_publisherGbifRegion_kingdom_basisOfRecord
  SELECT
    snapshot,
    publisher_gbif_region,
    CAST(COALESCE(kingdom_id, 0) AS VARCHAR) AS kingdom_id,
    COALESCE(basis_of_record, 'UNKNOWN') AS basis_of_record,
    CAST(COUNT(*) AS VARCHAR) AS occurrence_count
  FROM snapshots
  GROUP BY
    snapshot,
    publisher_gbif_region,
    COALESCE(kingdom_id, 0),
    COALESCE(basis_of_record, 'UNKNOWN');


DROP TABLE IF EXISTS occ_kingdom_basisOfRecord;
CREATE TABLE occ_kingdom_basisOfRecord
WITH (format = 'CSV')
AS SELECT
  snapshot,
  kingdom_id,
  basis_of_record,
  CAST(SUM(CAST(occurrence_count AS BIGINT)) AS VARCHAR) AS occurrence_count
FROM occ_country_kingdom_basisOfRecord
GROUP BY
  snapshot, kingdom_id, basis_of_record;
