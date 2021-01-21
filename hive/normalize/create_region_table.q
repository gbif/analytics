SET hive.exec.compress.output=false;

DROP TABLE IF EXISTS snapshot.tmp_regions;
CREATE TABLE snapshot.tmp_regions (country string, gbif_region string) row format delimited fields terminated by '\t';
LOAD DATA LOCAL INPATH '${hiveconf:regionTable}' OVERWRITE INTO TABLE snapshot.tmp_regions;
