#!/bin/bash
# builds intermediate interp tables (geo and taxonomy). NOTE: make sure the epsg-hsql jar is the right version for the latest release of occurrence-hive!

curl -SsLo /tmp/occurrence-hive.jar 'http://repository.gbif.org/service/local/artifact/maven/redirect?r=releases&g=org.gbif.occurrence&a=occurrence-hive&v=RELEASE&c=jar-with-dependencies'
curl -SsLo /tmp/gt-epsg-hsql.jar 'http://download.osgeo.org/webdav/geotools/org/geotools/gt-epsg-hsql/12.1/gt-epsg-hsql-12.1.jar'
hive --hiveconf occjar=/tmp/occurrence-hive.jar --hiveconf props=hive/normalize/occurrence-processor.properties --hiveconf epsgjar=/tmp/gt-epsg-hsql.jar --hiveconf api=http://api.gbif.org/v1 --hiveconf mapcount=100 -f hive/normalize/interp_geo.q
hive --hiveconf occjar=/tmp/occurrence-hive.jar --hiveconf props=hive/normalize/occurrence-processor.properties --hiveconf mapcount=100 --hiveconf api=http://api.gbif.org/v1 -f hive/normalize/interp_taxonomy.q
