DROP TABLE IF EXISTS snapshot.tmp_regions;

CREATE TABLE snapshot.tmp_regions (country varchar, gbif_region varchar)
WITH (FORMAT = 'CSV',
    csv_separator = ';',
    EXTERNAL_LOCATION = 'hdfs://gbif-hdfs/analytics/regions');

