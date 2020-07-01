#!/bin/bash
# Generates the hive query that prepares the one big table of occurrences for subsequent hive processing. Single argument is the name of the "prepare.q" file
# Note that single ' and double " quotes are used carefully in the echos below - not arbitrarily.

prepare_file="$1"

declare -a snapshots=("20071219" "20080401" "20080627" "20081010" "20081217" "20090406" "20090617" "20090925" "20091216" "20100401" "20100726" "20101117" "20110221" "20110610" "20110905" "20120118" "20120326" "20120713" "20121031" "20121211" "20130220" "20130521" "20130709" "20130910" "20131220" "20140328" "20140908" "20150119" "20150409" "20150703" "20151001" "20160104" "20160405" "20160704" "20161007" "20161227" "20170412" "20170724" "20171012" "20171222" "20180409" "20180711" "20180928" "20190101" "20190406" "20190701" "20191009" "20200101" "20200401" "20200701")
max=$(( ${#snapshots[*]} - 1 ))
last_snapshot=${snapshots[$max]}

echo '--
-- Unions all the snapshots into a single table
--

-- the union all means we can run in parallel
SET hive.exec.parallel=true;

-- Use Snappy
SET hive.exec.compress.output=true;
SET mapred.output.compressiot.type=BLOCK;
SET mapred.output.compressiot.codec=org.apache.hadoop.io.compress.SnappyCodec;

-- Set up memory for YARN
SET mapreduce.map.memory.mb = 4096;
SET mapreduce.reduce.memory.mb = 4096;
SET mapreduce.map.java.opts = -Xmx3072m;
SET mapreduce.reduce.java.opts = -Xmx3072m;

CREATE DATABASE IF NOT EXISTS ${hiveconf:DB};
DROP TABLE IF EXISTS ${hiveconf:DB}.snapshots;

CREATE TABLE ${hiveconf:DB}.snapshots STORED AS ORC AS
SELECT * FROM
(' > $prepare_file

for snapshot in "${snapshots[@]}"
do
  tmptable=${snapshot:0:4}-${snapshot:4:2}-${snapshot:6:2}
  echo "SELECT '${tmptable}'"' AS snapshot, CAST(id AS BIGINT), CAST(dataset_id AS String) AS dataset_id, CAST(publisher_id AS String) AS publisher_id, kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id, family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country FROM ${hiveconf:SNAPSHOT_DB}.occurrence_'"$snapshot" >> $prepare_file
  if [[ $snapshot != $last_snapshot ]]; then
    echo "UNION ALL" >> $prepare_file
  fi
done

echo ") t1" >> $prepare_file
