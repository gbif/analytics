
-- this needed on 0.13+
SET hive.support.quoted.identifiers=none;

-- DROP TABLE IF EXISTS ${hiveconf:snapshotdb}.raw_${hiveconf:snapshot};
CREATE TABLE ${hiveconf:snapshotdb}.raw_${hiveconf:snapshot} STORED AS ORC AS SELECT gbifid AS id, datasetkey AS dataset_id, publishingorgkey AS publisher_id, publishingcountry AS publisher_country, `v_.*` FROM ${hiveconf:sourcedb}.${hiveconf:sourcetable};
