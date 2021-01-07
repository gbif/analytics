#!/bin/bash
# builds intermediate interp tables (geo and taxonomy). NOTE: make sure the epsg-hsql jar is the right version for the latest release of occurrence-hive!

log () {
  echo $(tput setaf 6)$(date '+%Y-%m-%d %H:%M:%S ')$(tput setaf 14)$1$(tput sgr0)
}

SONAR_REDIRECT_URL=http://repository.gbif.org/repository/gbif/org/gbif/occurrence/occurrence-hive
VERSION=$(xmllint --xpath "string(//release)" <(curl -s "${SONAR_REDIRECT_URL}/maven-metadata.xml"))
FILENAME=occurrence-hive-${VERSION}-jar-with-dependencies.jar
SONAR_DOWNLOAD_URL=${SONAR_REDIRECT_URL}/${VERSION}/${FILENAME}
curl -SsLo /tmp/occurrence-hive.jar "${SONAR_REDIRECT_URL}/${VERSION}/${FILENAME}"

curl -SsLo /tmp/gt-epsg-hsql.jar 'http://download.osgeo.org/webdav/geotools/org/geotools/gt-epsg-hsql/20.5/gt-epsg-hsql-20.5.jar'
log 'Building intermediate interp geo tables'
hive --hiveconf occjar=/tmp/occurrence-hive.jar \
     --hiveconf props=hive/normalize/occurrence-processor.properties \
     --hiveconf epsgjar=/tmp/gt-epsg-hsql.jar \
     --hiveconf api=http://api.gbif.org/v1/ \
     --hiveconf cacheTable=geocode_gadm_kv --hiveconf cacheBuckets=50 --hiveconf cacheZk=c5zk1.gbif.org \
     -f hive/normalize/interp_geo.q
log 'Building intermediate interp taxonomy tables'
hive --hiveconf occjar=/tmp/occurrence-hive.jar \
     --hiveconf props=hive/normalize/occurrence-processor.properties \
     --hiveconf api=http://api.gbif.org/v1/ \
     -f hive/normalize/interp_taxonomy.q
