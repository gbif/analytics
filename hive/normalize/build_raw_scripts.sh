#!/bin/bash
# Generates the two hive queries that build the raw_geo and raw_taxonomy tables (distincted coords and taxonomy from the raw occurrence records).

declare -a mysql_snapshots=("20071219" "20080401" "20080627" "20081010" "20081217" "20090406" "20090617" "20090925" "20091216" "20100401" "20100726" "20101117" "20110221" "20110610" "20110905" "20120118" "20120326" "20120713" "20121031" "20121211" "20130220" "20130521" "20130709" "20130910")
declare -a hbase_v1_snapshots=("20131220" "20140328")
declare -a hbase_v2_snapshots=("20140908" "20150119")

max=$(( ${#hbase_v2_snapshots[*]} - 1 ))
last_modern_snapshot=${hbase_v2_snapshots[$max]}

################ RAW TAXONOMY SCRIPT
taxonomy_file="hive/normalize/raw_taxonomy.q"

echo '
-- Use Snappy
SET hive.exec.compress.output=true;
SET mapred.output.compression.type=BLOCK;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;

-- the union all means we can run in parallel
SET hive.exec.parallel=true;

DROP TABLE IF EXISTS snapshot.tmp_raw_taxonomy;
CREATE TABLE snapshot.tmp_raw_taxonomy STORED AS RCFILE AS
SELECT
  CONCAT_WS("|", 
    t1.kingdom, 
    t1.phylum, 
    t1.class_rank,
    t1.order_rank,
    t1.family,
    t1.genus,
    t1.scientific_name,
    t1.author
  ) AS taxon_key,
  t1.kingdom, 
  t1.phylum, 
  t1.class_rank, 
  t1.order_rank, 
  t1.family, 
  t1.genus, 
  t1.scientific_name, 
  t1.author
FROM 
  (' > $taxonomy_file
  
old_snapshots=( ${mysql_snapshots[@]} ${hbase_v1_snapshots[@]} )
for snapshot in "${old_snapshots[@]}"
do
  echo '
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_'"$snapshot"'
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL' >> "$taxonomy_file"
done

for snapshot in "${hbase_v2_snapshots[@]}"
do
  echo '
    SELECT COALESCE(v_kingdom,"") AS kingdom, COALESCE(v_phylum,"") AS phylum, COALESCE(v_class,"") AS class_rank, COALESCE(v_order_,"") AS order_rank, COALESCE(v_family,"") AS family, COALESCE(v_genus,"") AS genus, COALESCE(v_scientificname,"") AS scientific_name, COALESCE(v_scientificnameauthorship,"") AS author
    FROM snapshot.raw_'"$snapshot"'
    GROUP BY COALESCE(v_kingdom,""), COALESCE(v_phylum,""), COALESCE(v_class,""), COALESCE(v_order_,""), COALESCE(v_family,""), COALESCE(v_genus,""), COALESCE(v_scientificname,""), COALESCE(v_scientificnameauthorship,"")' >> $taxonomy_file
  
  if [[ $snapshot != $last_modern_snapshot ]]; then
    echo "UNION ALL" >> $taxonomy_file
  fi
done
    
echo '
) t1
GROUP BY
  t1.kingdom, 
  t1.phylum,
  t1.class_rank,
  t1.order_rank,
  t1.family, 
  t1.genus, 
  t1.scientific_name,
  t1.author;' >> "$taxonomy_file"


################ RAW GEO SCRIPT
geo_file="hive/normalize/raw_geo.q"

echo '
-- Use Snappy
SET hive.exec.compress.output=true;
SET mapred.output.compression.type=BLOCK;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;

-- the union all means we can run in parallel
SET hive.exec.parallel=true;

DROP TABLE IF EXISTS snapshot.tmp_raw_geo;
CREATE TABLE snapshot.tmp_raw_geo STORED AS RCFILE AS
SELECT
  CONCAT_WS("|", 
    t1.latitude, 
    t1.longitude, 
    t1.country
  ) AS geo_key,
  t1.latitude, 
  t1.longitude, 
  t1.country
FROM 
  (' > "$geo_file"

old_snapshots=( ${mysql_snapshots[@]} ${hbase_v1_snapshots[@]} )
for snapshot in "${old_snapshots[@]}"
do
  echo '
  SELECT COALESCE(latitude,"") AS latitude, COALESCE(longitude,"") AS longitude, COALESCE(country,"") AS country
  FROM snapshot.raw_'"$snapshot"'
  GROUP BY COALESCE(latitude,""), COALESCE(longitude,""), COALESCE(country,"")
  
  UNION ALL' >> "$geo_file"
done

for snapshot in "${hbase_v2_snapshots[@]}"
do
  echo '
  SELECT COALESCE(v_decimallatitude,v_verbatimlatitude,"") AS latitude, COALESCE(v_decimallongitude,v_verbatimlongitude,"") AS longitude, COALESCE(v_country,"") AS country
  FROM snapshot.raw_'"$snapshot"'
  GROUP BY COALESCE(v_decimallatitude,v_verbatimlatitude,""), COALESCE(v_decimallongitude,v_verbatimlongitude,""), COALESCE(v_country,"")' >> $geo_file
  
  if [[ $snapshot != $last_modern_snapshot ]]; then
    echo "UNION ALL" >> $geo_file
  fi
done
    
echo '
) t1
GROUP BY t1.latitude,t1.longitude,t1.country;' >> "$geo_file"
