##Analytics

> This is the source repository for the site http://analytics.gbif-uat.org which is currently under development.

### What are the analytics?
GBIF have started development to capture various metrics and enable monitoring of data trends.
The development is being done in an open manner, to enable others to verify procedures, contribute, or fork the project for their own purposes.  The early development results are visible on http://analytics.gbif-uat.org which currently show global and country specific charts illustrating the changes observed in the GBIF index since 2007.

Please note that all samples of the index have been reprocessed to **consistent quality control** and to the **same taxonomic backbone** to enable comparisons over time.  This is the first time this analysis has been possible, and is thanks to the adoption of the Hadoop environment at GBIF which enables the large scale analysis.  In total there are approximately 8 Billion records being analysed for these reports.

### Project structure
The project is divided into several parts:
- Hive and sqoop scripts which are responsible for importing historical data from archived MySQL database dumps
- Hive scripts that import recent data from the latest GBIF infrastructure (the real time indexing system currently serving GBIF)
- Hive scripts that process all data to the same quality control and taxonomic backbone
- Hive scripts that digest the data into specific views suitable for download from Hadoop and further processing
- R scripts that process the data into views per country
- R scripts that produce the static charts for each country
- R scripts that produce the json files used by the gbif.org/analytics
- R scripts that use moustache templating to produce the old static site

### Steps for adding a new snapshot and then re-running the processing
- Make sure hadoop libraries and binaries (e.g. hive) are on your path
- The snapshot name will be the date as yyyyMMdd so e.g. 20140923.
- Create new "raw" table from either live hbase or from a restored occurrence backup using ´´´hive/import/hbase/create_hbase_snapshot.sh´´´. Pass in snapshot name, source hive db and source hive table e.g. ´´´create_hbase_snapshot.sh 20140923 prod_b occurrence_hbase´´´
- Add the new snapshot name to the ´´´hive/normalize/build_raw_scripts.sh´´´ script, to the array hbase_v2_snapshots. If the hbase schema has changed you'll have to add a new array called e.g. hbase_v3_snapshots and add logic to process that array at the bottom of the script (another loop).
- Add the new snapshot name to ´´´hive/normalize/create_occurrence_tables.sh´´´ in the same way as above.
- Add the new snapshot name to ´´´hive/process/build_prepare_script.sh´´´ in the same way as above.
- Make sure the version of epsg used in the latest occurrence-hive pom.xml is the same as the one that the script ´´´hive/normalize/create_tmp_interp_tables.sh´´´ fetches.  
- From the root (analytics) directory you can now run the build.sh script to run all the HBase and Hive table building, build all the master csv files, which are in turn processed down to per country csvs, then generate the figures and the final json file needed by gbif.org/analytics. Note that this will take up to 48 hours and is unfortunately error prone, so all steps could also be run individually. In any case it's probably best to run all parts of this script on a machine in the secretariat and ideally in a "screen" session. To run it all do: 

  ´´´build.sh -runHbase -runHive -runHadoop -runPrepare -runFigures -runJson´´´


### Acknowledgements
The work presented here is not new, and builds on ideas already published.  In particular the work of Javier Otegui, Arturo H. Ariño, María A. Encinas, Francisco Pando (http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0055144) was used as inspiration during the first development iteration, and Javier Otegui kindly provided a crash course in R to kickstart the development.  



