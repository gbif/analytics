#!/bin/bash
# Builds the occurrence_<date> tables. create_tmp_interp_tables.sh has to be run before this one

log () {
  echo $(tput setaf 6)$(date '+%Y-%m-%d %H:%M:%S ')$(tput setaf 14)$1$(tput sgr0)
}

SONAR_REDIRECT_URL=http://repository.gbif.org/repository/gbif/org/gbif/occurrence/occurrence-hive
VERSION=$(xmllint --xpath "string(//release)" <(curl -s "${SONAR_REDIRECT_URL}/maven-metadata.xml"))
FILENAME=occurrence-hive-${VERSION}-jar-with-dependencies.jar
SONAR_DOWNLOAD_URL=${SONAR_REDIRECT_URL}/${VERSION}/${FILENAME}
curl -SsLo /tmp/occurrence-hive.jar "${SONAR_REDIRECT_URL}/${VERSION}/${FILENAME}"

declare -a mysql_snapshots=("20071219" "20080401" "20080627" "20081010" "20081217" "20090406" "20090617" "20090925" "20091216" "20100401" "20100726" "20101117" "20110221" "20110610" "20110905" "20120118" "20120326" "20120713" "20121031" "20121211" "20130220" "20130521" "20130709" "20130910")
declare -a hbase_v1_snapshots=("20131220" "20140328")
declare -a hbase_v2_snapshots=("20140908" "20150119" "20150409")
declare -a hbase_v3_snapshots=("20150703" "20151001" "20160104" "20160405" "20160704" "20161007" "20161227" "20170412" "20170724" "20171012" "20171222" "20180409" "20180711" "20180928" "20190101" "20190406" "20190701" "20191009")

log 'Creating MySQL snapshots'
for snapshot in "${mysql_snapshots[@]}"
do
    log "Creating MySQL snapshot $snapshot"
    hive --hiveconf occjar=/tmp/occurrence-hive.jar --hiveconf mapcount=100 --hiveconf snapshot="$snapshot" -f hive/normalize/occurrence_mysql.q
done

log 'Creating HBase V1 snapshots'
for snapshot in "${hbase_v1_snapshots[@]}"
do
    log "Creating HBase V1 snapshot $snapshot"
    hive --hiveconf occjar=/tmp/occurrence-hive.jar --hiveconf mapcount=100 --hiveconf snapshot="$snapshot" -f hive/normalize/occurrence_v1_hbase.q
done

log 'Creating HBase V2 snapshots'
for snapshot in "${hbase_v2_snapshots[@]}"
do
    log "Creating HBase V2 snapshot $snapshot"
    hive --hiveconf occjar=/tmp/occurrence-hive.jar --hiveconf mapcount=100 --hiveconf snapshot="$snapshot" -f hive/normalize/occurrence_v2_hbase.q
done

log 'Creating HBase V3 snapshots'
for snapshot in "${hbase_v3_snapshots[@]}"
do
    log "Creating HBase V3 snapshot $snapshot"
    hive --hiveconf occjar=/tmp/occurrence-hive.jar --hiveconf mapcount=100 --hiveconf snapshot="$snapshot" -f hive/normalize/occurrence_v3_hbase.q
done
