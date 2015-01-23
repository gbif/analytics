-- this will only work if the hbase schema hasn't changed!
ADD JAR ${hiveconf:hivehbase};
-- hbase not needed in cdh5+
-- ADD JAR ${hiveconf:hbase};

-- this needed on 0.13+
SET hive.support.quoted.identifiers=none;

DROP TABLE IF EXISTS ${hiveconf:snapshotdb}.raw_${hiveconf:snapshot};
CREATE TABLE ${hiveconf:snapshotdb}.raw_${hiveconf:snapshot} STORED AS RCFILE as select gbifid AS id, datasetkey AS dataset_id, publishingorgkey AS publisher_id, publishingcountry AS publisher_country, `v_.*` from ${hiveconf:sourcedb}.${hiveconf:sourcetable};
