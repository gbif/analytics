#!/bin/bash
# builds intermediate interp tables (geo and taxonomy). NOTE: make sure the epsg-hsql jar is the right version for the latest release of occurrence-hive!

curl -L 'http://repository.gbif.org/service/local/artifact/maven/redirect?r=releases&g=org.gbif.occurrence&a=occurrence-hive&v=RELEASE&c=jar-with-dependencies' > /tmp/occurrence-hive.jar
curl -L 'http://download.osgeo.org/webdav/geotools/org/geotools/gt-epsg-hsql/11.1/gt-epsg-hsql-11.1.jar' > /tmp/gt-epsg-hsql.jar
hive --hiveconf occjar=/tmp/occurrence-hive.jar --hiveconf epsgjar=/tmp/gt-epsg-hsql.jar --hiveconf mapcount=25 -f interp_geo.q
hive --hiveconf occjar=/tmp/occurrence-hive.jar --hiveconf mapcount=25 -f interp_taxonomy.q