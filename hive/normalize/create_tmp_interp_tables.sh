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

if [[ ! -e /home/hdfs/occurrence-hive-udf-kvs.jar ]] then;
    echo "Build the udf-kvs branch of occurrence-hive, copy to /home/hdfs/occurrence-hive-udf-kvs.jar"
    exit 1
fi

# Last known working version for species matching
curl -SsLo /home/hdfs/occurrence-hive-0.129.jar https://repository.gbif.org/repository/gbif/org/gbif/occurrence/occurrence-hive/0.129/occurrence-hive-0.129-jar-with-dependencies.jar

curl -SsLo /tmp/gt-epsg-hsql.jar 'http://download.osgeo.org/webdav/geotools/org/geotools/gt-epsg-hsql/20.5/gt-epsg-hsql-20.5.jar'

log 'Building intermediate interp geo tables'
hive --hiveconf occjar=/home/hdfs/occurrence-hive-udf-kvs.jar \
     --hiveconf props=hive/normalize/occurrence-processor.properties \
     --hiveconf epsgjar=/tmp/gt-epsg-hsql.jar \
     --hiveconf api=http://api.gbif.org/v1/ \
     --hiveconf cacheTable=geocode_gadm_kv --hiveconf cacheBuckets=50 --hiveconf cacheZk=c5zk1.gbif.org \
     -f hive/normalize/interp_geo.q
log 'Building intermediate interp taxonomy tables'
hive --hiveconf occjar=/home/hdfs/occurrence-hive-0.129.jar \
     --hiveconf props=hive/normalize/occurrence-processor.properties \
     --hiveconf api=http://api.gbif.org/v1/ \
     -f hive/normalize/interp_taxonomy.q

log 'Building country→gbifRegion map table'
(
	curl -Ssg https://api.gbif.org/v1/enumeration/country | jq -r '.[] | "\(.iso2)\t\(.gbifRegion)"'
	# Snapshots 2010-04-01 and 2010-07-26 contain UK values.
	echo -e "UK\tEUROPE"
	echo -e "XK\tEUROPE"
) | sort | sort -k2 > /tmp/analytics_regions.tsv
hive --hiveconf regionTable=/tmp/analytics_regions.tsv \
	 -f hive/normalize/create_region_table.q
