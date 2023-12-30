#!/bin/bash
# builds intermediate interp tables (geo and taxonomy). NOTE: make sure the epsg-hsql jar is the right version for the latest release of occurrence-hive!

log () {
  echo $(tput setaf 6)$(date '+%Y-%m-%d %H:%M:%S ')$(tput setaf 14)$1$(tput sgr0)
}

#SONAR_REDIRECT_URL=http://repository.gbif.org/repository/gbif/org/gbif/occurrence/occurrence-hive
#VERSION=$(xmllint --xpath "string(//release)" <(curl -s "${SONAR_REDIRECT_URL}/maven-metadata.xml"))
#FILENAME=occurrence-hive-${VERSION}-jar-with-dependencies.jar
#SONAR_DOWNLOAD_URL=${SONAR_REDIRECT_URL}/${VERSION}/${FILENAME}
#curl -SsLo /tmp/occurrence-hive.jar "${SONAR_REDIRECT_URL}/${VERSION}/${FILENAME}"

if [[ ! -e /home/hdfs/occurrence-hive-0.187-SNAPSHOT.jar ]]; then
    echo "Build the dev branch of occurrence-hive, copy to /home/hdfs/occurrence-hive-0.187-SNAPSHOT.jar"
    exit 1
fi

# Last known working version for species matching
curl -SsLo /home/hdfs/occurrence-hive-0.129.jar https://repository.gbif.org/repository/gbif/org/gbif/occurrence/occurrence-hive/0.129/occurrence-hive-0.129-jar-with-dependencies.jar

curl -SsLo /tmp/gt-epsg-hsql.jar 'http://download.osgeo.org/webdav/geotools/org/geotools/gt-epsg-hsql/20.5/gt-epsg-hsql-20.5.jar'

log 'Building intermediate interp geo tables'
hive --hiveconf occjar=/home/hdfs/occurrence-hive-0.187-SNAPSHOT.jar \
     --hiveconf epsgjar=/tmp/gt-epsg-hsql.jar \
     --hiveconf layerSource=/mnt/auto/maps/geocode/layers/ \
     -f hive/normalize/interp_geo.q

# Use the webservice directly.
# (There's no use to the caching, every query is different. And it's a huge load on Varnish.)
log 'Finding address of checklistbank-nub-ws'
#zk_servers=c5zk1.gbif.org,c5zk2.gbif.org,c5zk3.gbif.org
#clb_nub_zk_node=$(zookeeper-client -server $zk_servers ls /prod/services/checklistbank-nub-ws 2> /dev/null | grep --only-matching ........-....-....-....-............ | tail -n 1)
#clb_nub_host=$(zookeeper-client -server $zk_servers get /prod/services/checklistbank-nub-ws/$clb_nub_zk_node 2> /dev/null | grep $clb_nub_zk_node | tail -n 1 | jq -r .address)
#clb_nub_port=$(zookeeper-client -server $zk_servers get /prod/services/checklistbank-nub-ws/$clb_nub_zk_node 2> /dev/null | grep $clb_nub_zk_node | tail -n 1 | jq -r .port)
#clb_nub_location=http://$clb_nub_host:$clb_nub_port/
# Needs to be set, otherwise prodws gets too slow.
clb_nub_location=http://ws2.gbif.org:7000/
# Check curl -s 'http://ws2.gbif.org:7000/species/match?verbose=true&name=Abies'
log "Address is $clb_nub_location"

log 'Building intermediate interp taxonomy tables'
hive --hiveconf occjar=/home/hdfs/occurrence-hive-0.129.jar \
     --hiveconf api=$clb_nub_location \
     -f hive/normalize/interp_taxonomy.q

log 'Building country→gbifRegion map table'
(
	curl -Ssg https://api.gbif.org/v1/enumeration/country | jq -r '.[] | "\(.iso2)\t\(.gbifRegion)"'
	# Kosovo's code isn't shown in that enumeration
	echo -e "XK\tEUROPE"
	# Snapshots 2010-04-01 and 2010-07-26 contain UK values.
	echo -e "UK\tEUROPE"
) | sort | sort -k2 > /tmp/analytics_regions.tsv
hive --hiveconf regionTable=/tmp/analytics_regions.tsv \
     -f hive/normalize/create_region_table.q
