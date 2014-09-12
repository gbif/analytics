#!/bin/bash
# Builds the occurrence_<date> tables. create_tmp_interp_tables.sh has to be run before this one

curl -L 'http://repository.gbif.org/service/local/artifact/maven/redirect?r=releases&g=org.gbif.occurrence&a=occurrence-hive&v=RELEASE&c=jar-with-dependencies' > /tmp/occurrence-hive.jar

declare -a mysql_snapshots=("20071219" "20080401" "20080627" "20081010" "20081217" "20090406" "20090617" "20090925" "20091216" "20100401" "20100726" "20101117" "20110221" "20110610" "20110905" "20120118" "20120326" "20120713" "20121031" "20121211" "20130220" "20130521" "20130709" "20130910")
declare -a hbase_interim_snapshots=("20131220" "20140328")
declare -a hbase_modern_snapshots=("20140908")

for snapshot in "${mysql_snapshots[@]}"
do
   hive --hiveconf occjar=/tmp/occurrence-hive.jar --hiveconf mapcount=100 --hiveconf snapshot="$snapshot" -f occurrence_mysql.q
done

for snapshot in "${hbase_interim_snapshots[@]}"
do
   hive --hiveconf occjar=/tmp/occurrence-hive.jar --hiveconf mapcount=100 --hiveconf snapshot="$snapshot" -f occurrence_interim_hbase.q
done

for snapshot in "${hbase_modern_snapshots[@]}"
do
   hive --hiveconf occjar=/tmp/occurrence-hive.jar --hiveconf mapcount=100 --hiveconf snapshot="$snapshot" -f occurrence_modern_hbase.q
done