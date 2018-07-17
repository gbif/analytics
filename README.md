## Analytics

This is the source repository for the site https://www.gbif.org/analytics.

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.231055.svg)](https://doi.org/10.5281/zenodo.231055)

### What are the analytics?
GBIF capture various metrics to enable monitoring of data trends.
The development is being done in an open manner, to enable others to verify procedures, contribute, or fork the project for their own purposes.  The results are visible on https://www.gbif.org/analytics/global and show global and country specific charts illustrating the changes observed in the GBIF index since 2007.

Please note that all samples of the index have been reprocessed to **consistent quality control** and to the **same taxonomic backbone** to enable comparisons over time.  This is the first time this analysis has been possible, and is thanks to the adoption of the Hadoop environment at GBIF which enables the large scale analysis.  In total there are approximately 19 billion (to summer 2018) records being analysed for these reports.

### Project structure
The project is divided into several parts:
- Hive and Sqoop scripts which are responsible for importing historical data from archived MySQL database dumps
- Hive scripts that import recent data from the latest GBIF infrastructure (the real time indexing system currently serving GBIF)
- Hive scripts that process all data to the same quality control and taxonomic backbone
- Hive scripts that digest the data into specific views suitable for download from Hadoop and further processing
- R scripts that process the data into views per country
- R scripts that produce the static charts for each country

### Steps for adding a new snapshot and then re-running the processing
- This will only work on a Cloudera Manager managed gateway such as ```c5gateway-vh``` on which you should be able to `sudo su - hdfs` and find the code in `/home/hdfs/analytics/` (do a `git pull`)
- Make sure Hadoop libraries and binaries (e.g. hive) are on your path
- The snapshot name will be the date as ```YYYYMMDD``` so e.g. ```20140923```.
- Create new "raw" table from either live HBase or from a restored occurrence backup using ```hive/import/hbase/create_new_snapshot.sh```. Pass in snapshot database, snapshot name, source Hive database and source Hive table e.g. ```hive/import/hbase/create_new_snapshot.sh snapshot 20150409 prod_b occurrence_hbase```
- Tell Matt he can run the backup script, which exports these snapshots to external storage.
- Add the new snapshot name to the ```hive/normalize/build_raw_scripts.sh``` script, to the array hbase_v3_snapshots. If the HBase schema has changed you'll have to add a new array called e.g. hbase_v4_snapshots and add logic to process that array at the bottom of the script (another loop).
- Add the new snapshot name to ```hive/normalize/create_occurrence_tables.sh``` in the same way as above.
- Add the new snapshot name to ```hive/process/build_prepare_script.sh``` in the same way as above.
- Replace the last element of `temporalFacetSnapshots` in ```R/graph/utils.R``` with your new snapshot. Follow the formatting in use, e.g. `2015-01-19`
- Make sure the version of EPSG used in the latest occurrence project pom.xml is the same as the one that the script ```hive/normalize/create_tmp_interp_tables.sh``` fetches. Do that by checking the pom.xml (hopefully still at: https://github.com/gbif/occurrence/blob/master/pom.xml) for the geotools.version. That version should be the same as what's in the shell script (at time of writing the geotools.version was 12.1 and the script line was ```curl -L 'http://download.osgeo.org/webdav/geotools/org/geotools/gt-epsg-hsql/12.1/gt-epsg-hsql-12.1.jar' > /tmp/gt-epsg-hsql.jar```)
- From the root (analytics) directory you can now run the build.sh script to run all the HBase and Hive table building, build all the master CSV files, which are in turn processed down to per country CSVs, then generate the figures needed for gbif.org/analytics and the country reports. Note that this will take up to 48 hours and is unfortunately error prone, so all steps could also be run individually. In any case it's probably best to run all parts of this script on a machine in the secretariat and ideally in a "screen" session. To run it all do:

  ```screen -L -S analytics```
  ```./build.sh -runHbase -runHive -runHadoop -runPrepare -runFigures```

  (Detach from the screen with "^A d", reattach with `screen -x`.)

  or without a screen session and in the background:

  ```nohup ./build.sh -runHbase -runHive -runHadoop -runPrepare -runFigures &```

### Notes for figure produces (for country reports)
- Arial and Arial Narrow will be required on the machine from which the runFigures command is run. For Linux that means a new dir under /usr/share/fonts with the .ttf files from this project's fonts/ dir copied in (the provisioning project's Ansible scripts take care of this).
- the /usr/lib64/R/library/extrafontdb dir must be writeable by the user running the runFigures command because font stuff will be written there on first load

### Steps to build country reports after the R part is done
TODO update.
- rsync the reports to root@analytics-files.gbif-uat.org:/var/www/html/analytics-files/ and check (this server is also used for gbif-dev.org).
- Generate the country reports — check you are using correct APIs!
- Country reports are now run using https://github.com/gbif/country-reports.
- make a backup of the old analytics, TODO give command, and put it in Box. The old analytics files have been used several times by the communications team.
- rsync the reports to root@analytics-files.gbif.org:/var/www/html/analytics-files/
- check http://gbif.org/analytics, write an email to staff@gbif.org giving heads up on the new data, and accept the many accolades due your outstanding achievement in the field of excellence!

### Acknowledgements
The work presented here is not new, and builds on ideas already published.  In particular the work of Javier Otegui, Arturo H. Ariño, María A. Encinas, Francisco Pando (http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0055144) was used as inspiration during the first development iteration, and Javier Otegui kindly provided a crash course in R to kickstart the development.
