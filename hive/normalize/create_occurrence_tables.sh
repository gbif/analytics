#!/bin/bash
# Builds the occurrence_<date> tables. create_tmp_interp_tables.sh has to be run before this one

curl -L 'http://repository.gbif.org/service/local/artifact/maven/redirect?r=releases&g=org.gbif.occurrence&a=occurrence-hive&v=RELEASE&c=jar-with-dependencies' > /tmp/occurrence-hive.jar

#declare -a mysql_snapshots=("20071219" "20080401" "20080627" "20081010" "20081217" "20090406" "20090617" "20090925" "20091216" "20100401" "20100726" "20101117" "20110221" "20110610" "20110905" "20120118" "20120326" "20120713" "20121031" "20121211" "20130220" "20130521" "20130709" "20130910")
#declare -a hbase_v1_snapshots=("20131220" "20140328")
#declare -a hbase_v2_snapshots=("20140908" "20150119" "20150409")
declare -a hbase_v3_snapshots=("20150703" "20151001" "20160104" "20160504")

#echo 'creating mysql snapshots'
#for snapshot in "${mysql_snapshots[@]}"
#do
#  hive --hiveconf occjar=/tmp/occurrence-hive.jar --hiveconf mapcount=100 --hiveconf snapshot="$snapshot" -f hive/normalize/occurrence_mysql.q
#done

#echo 'creating hbase_v1_snapshots'
#for snapshot in "${hbase_v1_snapshots[@]}"
#do
#   hive --hiveconf occjar=/tmp/occurrence-hive.jar --hiveconf mapcount=100 --hiveconf snapshot="$snapshot" -f hive/normalize/occurrence_v1_hbase.q
#done

#echo 'creating hbase_v2_snapshots'
#for snapshot in "${hbase_v2_snapshots[@]}"
#do
#   hive --hiveconf occjar=/tmp/occurrence-hive.jar --hiveconf mapcount=100 --hiveconf snapshot="$snapshot" -f hive/normalize/occurrence_v2_hbase.q
#done

echo 'creating hbase_v3_snapshots'
for snapshot in "${hbase_v3_snapshots[@]}"
do
   hive --hiveconf occjar=/tmp/occurrence-hive.jar --hiveconf mapcount=100 --hiveconf snapshot="$snapshot" -f hive/normalize/occurrence_v3_hbase.q
done
