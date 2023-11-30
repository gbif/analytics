DROP TABLE IF EXISTS tmp_regions;

CREATE TABLE tmp_regions (country varchar, gbif_region varchar)
WITH (FORMAT = 'CSV',
    skip_header_line_count = 1,
    csv_separator = U&'\0009',
    EXTERNAL_LOCATION = '/tmp/regions');
