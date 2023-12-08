#!/bin/bash
# Generates the two hive queries that build the raw_geo and raw_taxonomy tables (distincted coords and taxonomy from the raw occurrence records).

#declare -a mysql_snapshots=("20071219" "20080401" "20080627" "20081010" "20081217" "20090406" "20090617" "20090925" "20091216" "20100401" "20100726" "20101117" "20110221" "20110610" "20110905" "20120118" "20120326" "20120713" "20121031" "20121211" "20130220" "20130521" "20130709" "20130910")
#declare -a hbase_v1_snapshots=("20131220" "20140328")
#declare -a hbase_v2_snapshots=("20140908" "20150119" "20150409")
## v3 exists only because of a tiny difference in taxonomy schema (v_order_ became v_order)
#declare -a hbase_v3_snapshots=("20150703" "20151001" "20160104" "20160405" "20160704" "20161007" "20161227" "20170412" "20170724" "20171012" "20171222" "20180409" "20180711" "20180928" "20190101" "20190406" "20190701" "20191009")
#declare -a hdfs_v1_snapshots=("20200101" "20200401" "20200701" "20201001" "20210101" "20210401" "20210701" "20211001" "20220101" "20220401" "20220701" "20221001" "20230101" "20230401" "20230701" "20211001")

declare -a mysql_snapshots=()
declare -a hbase_v1_snapshots=()
declare -a hbase_v2_snapshots=()
# v3 exists only because of a tiny difference in taxonomy schema (v_order_ became v_order)
declare -a hbase_v3_snapshots=()
declare -a hdfs_v1_snapshots=()

max=$(( ${#hdfs_v1_snapshots[*]} - 1 ))
last_modern_snapshot=${hdfs_v1_snapshots[$max]}

################ RAW TAXONOMY SCRIPT
taxonomy_file="hive/normalize/raw_taxonomy.q"

echo "
-- THIS FILE IS GENERATED.  DO NOT EDIT BY HAND !!!

DROP TABLE IF EXISTS snapshot.tmp_raw_taxonomy;
CREATE TABLE snapshot.tmp_raw_taxonomy
WITH (format = 'ORC')
AS
SELECT
  CONCAT_WS('|',
    t1.kingdom,
    t1.phylum,
    t1.class_rank,
    t1.order_rank,
    t1.family,
    t1.genus,
    t1.scientific_name,
    t1.specific_epithet,
    t1.infra_specific_epithet,
    t1.author,
    t1.rank
  ) AS taxon_key,
  t1.kingdom,
  t1.phylum,
  t1.class_rank,
  t1.order_rank,
  t1.family,
  t1.genus,
  t1.scientific_name,
  t1.specific_epithet,
  t1.infra_specific_epithet,
  t1.author,
  t1.rank
FROM
  (" > $taxonomy_file

for snapshot in "${mysql_snapshots[@]}"
do
  echo "
    SELECT COALESCE(kingdom,'') AS kingdom, COALESCE(phylum,'') AS phylum, COALESCE(class_rank,'') AS class_rank, COALESCE(order_rank,'') AS order_rank, COALESCE(family,'') AS family, COALESCE(genus,'') AS genus, COALESCE(scientific_name,'') AS scientific_name, COALESCE(species,'') AS specific_epithet, COALESCE(subspecies,'') AS infra_specific_epithet, COALESCE(author,'') AS author, COALESCE(rank,'') AS rank
    FROM snapshot.raw_$snapshot
    GROUP BY COALESCE(kingdom,''), COALESCE(phylum,''), COALESCE(class_rank,''), COALESCE(order_rank,''), COALESCE(family,''), COALESCE(genus,''), COALESCE(scientific_name,''), COALESCE(author,''), COALESCE(rank,''), COALESCE(species,''), COALESCE(subspecies,'')

    UNION ALL" >> "$taxonomy_file"
done

for snapshot in "${hbase_v1_snapshots[@]}"
do
  echo "
    SELECT COALESCE(kingdom,'') AS kingdom, COALESCE(phylum,'') AS phylum, COALESCE(class_rank,'') AS class_rank, COALESCE(order_rank,'') AS order_rank, COALESCE(family,'') AS family, COALESCE(genus,'') AS genus, COALESCE(scientific_name,'') AS scientific_name, COALESCE(specific_epithet,'') AS specific_epithet, COALESCE(infraspecific_epithet,'') AS infra_specific_epithet, COALESCE(author,'') AS author, COALESCE(taxon_rank,'') AS rank
    FROM snapshot.raw_$snapshot
    GROUP BY COALESCE(kingdom,''), COALESCE(phylum,''), COALESCE(class_rank,''), COALESCE(order_rank,''), COALESCE(family,''), COALESCE(genus,''), COALESCE(scientific_name,''), COALESCE(author,''), COALESCE(specific_epithet,''), COALESCE(infraspecific_epithet,''), COALESCE(taxon_rank,'')

    UNION ALL" >> "$taxonomy_file"
done

for snapshot in "${hbase_v2_snapshots[@]}"
do
  echo "
    SELECT COALESCE(v_kingdom,'') AS kingdom, COALESCE(v_phylum,'') AS phylum, COALESCE(v_class,'') AS class_rank, COALESCE(v_order_,'') AS order_rank, COALESCE(v_family,'') AS family, COALESCE(v_genus,'') AS genus, COALESCE(v_scientificname,'') AS scientific_name, COALESCE(v_specificepithet,'') AS specific_epithet, COALESCE(v_infraspecificepithet,'') AS infra_specific_epithet, COALESCE(v_scientificnameauthorship,'') AS author, COALESCE(v_taxonrank,'') AS rank
    FROM snapshot.raw_$snapshot
    GROUP BY COALESCE(v_kingdom,''), COALESCE(v_phylum,''), COALESCE(v_class,''), COALESCE(v_order_,''), COALESCE(v_family,''), COALESCE(v_genus,''), COALESCE(v_scientificname,''), COALESCE(v_scientificnameauthorship,''), COALESCE(v_specificepithet,''), COALESCE(v_infraspecificepithet,''), COALESCE(v_taxonrank,'')

    UNION ALL" >> $taxonomy_file
done

for snapshot in "${hbase_v3_snapshots[@]}" "${hdfs_v1_snapshots[@]}"
do
  echo "
    SELECT COALESCE(v_kingdom,'') AS kingdom, COALESCE(v_phylum,'') AS phylum, COALESCE(v_class,'') AS class_rank, COALESCE(v_order,'') AS order_rank, COALESCE(v_family,'') AS family, COALESCE(v_genus,'') AS genus, COALESCE(v_scientificname,'') AS scientific_name, COALESCE(v_specificepithet,'') AS specific_epithet, COALESCE(v_infraspecificepithet,'') AS infra_specific_epithet, COALESCE(v_scientificnameauthorship,'') AS author, COALESCE(v_taxonrank,'') AS rank
    FROM snapshot.raw_$snapshot
    GROUP BY COALESCE(v_kingdom,''), COALESCE(v_phylum,''), COALESCE(v_class,''), COALESCE(v_order,''), COALESCE(v_family,''), COALESCE(v_genus,''), COALESCE(v_scientificname,''), COALESCE(v_scientificnameauthorship,''), COALESCE(v_specificepithet,''), COALESCE(v_infraspecificepithet,''), COALESCE(v_taxonrank,'')" >> $taxonomy_file

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
  t1.specific_epithet,
  t1.infra_specific_epithet,
  t1.author,
  t1.rank
ORDER BY rand();' >> "$taxonomy_file"


################ RAW GEO SCRIPT
geo_file="hive/normalize/raw_geo.q"

echo "
-- THIS FILE IS GENERATED.  DO NOT EDIT BY HAND !!!

DROP TABLE IF EXISTS snapshot.tmp_raw_geo;
CREATE TABLE snapshot.tmp_raw_geo
WITH (format = 'ORC')
AS
SELECT
  CONCAT_WS('|',
    t1.latitude,
    t1.longitude,
    t1.country
  ) AS geo_key,
  t1.latitude,
  t1.longitude,
  t1.country
FROM
  (" > "$geo_file"

old_snapshots=( ${mysql_snapshots[@]} ${hbase_v1_snapshots[@]} )
for snapshot in "${old_snapshots[@]}"
do
  echo "
  SELECT COALESCE(latitude,'') AS latitude, COALESCE(longitude,'') AS longitude, COALESCE(country,'') AS country
  FROM snapshot.raw_$snapshot
  GROUP BY COALESCE(latitude,''), COALESCE(longitude,''), COALESCE(country,'')

  UNION ALL" >> "$geo_file"
done

new_snapshots=( ${hbase_v2_snapshots[@]} ${hbase_v3_snapshots[@]} ${hdfs_v1_snapshots[@]} )
for snapshot in "${new_snapshots[@]}"
do
  echo "
  SELECT COALESCE(v_decimallatitude,v_verbatimlatitude,'') AS latitude, COALESCE(v_decimallongitude,v_verbatimlongitude,'') AS longitude, COALESCE(v_country,'') AS country
  FROM snapshot.raw_$snapshot
  GROUP BY COALESCE(v_decimallatitude,v_verbatimlatitude,''), COALESCE(v_decimallongitude,v_verbatimlongitude,''), COALESCE(v_country,'')
  " >> $geo_file

  if [[ $snapshot != $last_modern_snapshot ]]; then
    echo "  UNION ALL" >> $geo_file
  fi
done


echo "
) t1
GROUP BY t1.latitude, t1.longitude, t1.country
ORDER BY rand();" >> "$geo_file"
