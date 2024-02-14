DROP TABLE IF EXISTS snapshot.tmp_regions;

CREATE TABLE snapshot.tmp_regions (country varchar, gbif_region varchar)
WITH (FORMAT = 'CSV',
    skip_header_line_count = 1,
    csv_separator = ';',
    EXTERNAL_LOCATION = 'hdfs://gbif-hdfs/tmp/regions');
