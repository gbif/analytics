CREATE SCHEMA IF NOT EXISTS marcos with (LOCATION='hdfs://gbif-hdfs/stackable/warehouse/marcos.db');

SET SESSION hive.compression_codec='SNAPPY';

# Steps to create tables
1. raw
2. raw_geo
3. raw_taxon
4. interp_geo
5. interp_taxon
6. create_regions.sh
7. region_table
8. occurrence_hdfs
9. create_snapshots_table
10. scripts in process folder


All these steps can be run by using the `create_tables.sh` script that is inside the import folder.

You need to pass the following parameters:
- DB name
- Trino password
- Path of the Kubetctl config

Example: ./create_tables.sh marcos ***** /Users/marcoslopezgonzalez/.kube/config


# Tests

I created the raw table in Hive with the same amount of records as the that we have in trino, although the data is different
and it resulted in trino tables being bigger. Anyway, queires seem faster in trino than in Hive, worst-case scenario for some
queries it takes the same time. Also, I can see that the creation and submission of the job takes much longer in Hive than
in trino. Also, in trino the first query takes much more time(2-3x) than the second and next queries. Also, using set the
hive compression codec to Snappy made queries much faster.

Sometimes it takes a bit for trino to start processing a query, could it be network issues?

Prepared statements: this was tested but it didn't bring any performance improvement. Also, the statements are only saved
in the session but can't be persisted to use them across multiple sessions.


## Query times

Tests done for 441862 records in both systems although the data is different in each of them. That made trino end up with
more data than hive in the tables created from the raw data.

### Trino

| Query           | 1st    | 2nd    | 3rd   |
|-----------------|--------|--------|-------|
| raw             | 11.33s | 9.73s  |       |
| raw_geo         | 2.96s  | 1.45s  | 1.52s |
| raw_taxon       | 4.31s  | 2.11s  |       |
| interp_geo      | 15.40s | 10.30s |       |
| interp_taxon    | 7.73m  | 2.93m  |       |
| occurrence_hdfs | 30.35s | 19.53s |       |
| snapshots       | 4.75s  | 4.16s  |       |
| occ_country_cell_one_deg | 2.40s  | 1.41s  |


### Hive

| Query     | 1st | 2nd      | 3rd     |
|-----------|---|----------|---------|
| raw       | 60.304s | 57.953s  |         |
| raw_geo   | 44.124s | 48.906s  | 46.305s |
| raw_taxon | 68.145s | 70.251s  | 70.272s |
| interp_geo | 21.51s | 22.244s  | 20.609s |
| interp_taxon | 872.952s | 416.124s |         |
| occurrence_hdfs | 70.621s | 68.51s  |       |
| snapshots       | 22.347s | 20.234s   |       |
| occ_country_cell_one_deg | 23.697s | 26.374s |       |



## Prepared Statement example

````
PREPARE interp_geo FROM
CREATE TABLE tmp_geo_interp
WITH (format = 'ORC')
AS
SELECT
  t1.geo_key,
  g.latitude,
  g.longitude,
  g.country
FROM (
  SELECT
    geo_key,
    parseGeo('/gbif/geocode-layers/', latitude, longitude, country) g
  FROM tmp_raw_geo
) t1;

EXECUTE interp_geo;
````
