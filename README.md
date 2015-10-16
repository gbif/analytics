##Analytics

> This is the source repository for the site http://gbif.org/analytics.

[![DOI](https://zenodo.org/badge/7464/gbif/analytics.svg)](http://dx.doi.org/10.5281/zenodo.14181)

### What are the analytics?
GBIF are capturing various metrics to enable monitoring of data trends.
The development is being done in an open manner, to enable others to verify procedures, contribute, or fork the project for their own purposes.  The early results are visible on http://gbif.org/analytics which currently show global and country specific charts illustrating the changes observed in the GBIF index since 2007.

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
- This will only work on a Cloudera Manager managed gateway such as ```prodgateway-vh``` 
- Make sure hadoop libraries and binaries (e.g. hive) are on your path
- The snapshot name will be the date as ```yyyyMMdd``` so e.g. ```20140923```.
- Create new "raw" table from either live hbase or from a restored occurrence backup using ```hive/import/hbase/create_new_snapshot.sh```. Pass in snapshot db, snapshot name, source hive db and source hive table e.g. ```hive/import/hbase/create_new_snapshot.sh snapshot 20150409 prod_b occurrence_hbase```
- Add the new snapshot name to the ```hive/normalize/build_raw_scripts.sh``` script, to the array hbase_v3_snapshots. If the hbase schema has changed you'll have to add a new array called e.g. hbase_v4_snapshots and add logic to process that array at the bottom of the script (another loop).
- Add the new snapshot name to ```hive/normalize/create_occurrence_tables.sh``` in the same way as above.
- Add the new snapshot name to ```hive/process/build_prepare_script.sh``` in the same way as above.
- Replace the last element of "temporalFacetSnapshots" in R/graph/utils.R with your new snapshot. Follow the formatting in use, e.g. 2015-01-19
- Make sure the version of epsg used in the latest occurrence project pom.xml is the same as the one that the script ```hive/normalize/create_tmp_interp_tables.sh``` fetches. Do that by checking the pom.xml (hopefully still at: https://github.com/gbif/occurrence/blob/master/pom.xml) for the geotools.version. That version should be the same as what's in the shell script (at time of writing the geotools.version was 12.1 and the script line was ```curl -L 'http://download.osgeo.org/webdav/geotools/org/geotools/gt-epsg-hsql/12.1/gt-epsg-hsql-12.1.jar' > /tmp/gt-epsg-hsql.jar```)
- If you're planning on using the country reports results generated during the build.sh run, you have to update the R/generate_indesign_merge_csv_for_mac.R script with:
  - the start and end dates of your report
  - how many countries per csv you want
  - the name of the root drive on the apple computer that will run the indesign merge (often "Macintosh HD" or "Macintosh SSD")
  - make sure you've read the README in the R/country-reports directory and created the Google Analytics token and database file
- From the root (analytics) directory you can now run the build.sh script to run all the HBase and Hive table building, build all the master csv files, which are in turn processed down to per country csvs, then generate the figures and the final json file needed by gbif.org/analytics. Note that this will take up to 48 hours and is unfortunately error prone, so all steps could also be run individually. In any case it's probably best to run all parts of this script on a machine in the secretariat and ideally in a "screen" session. To run it all do: 

  ```build.sh -runHbase -runHive -runHadoop -runPrepare -runFigures -runJson```
  
  or without a screen session and in the background:

  ```nohup build.sh -runHbase -runHive -runHadoop -runPrepare -runFigures -runJson &```

### Notes for country report producers
- Arial and Arial Narrow will be required on the machine from which the runFigures command is run. For linux that means a new dir under /usr/share/fonts with
the .ttf files from this project's fonts/ dir copied in (the provisioning project's ansible scripts take care of this).
- the /usr/lib64/R/library/extrafontdb dir must be writeable by the user running the runFigures command because font stuff will be written there on first load
- create the files described in https://github.com/gbif/analytics/blob/master/R/country-reports/README.md

### Steps to build country reports after the R part is done
The R part of country reports is finished after all the steps in the build.sh script are done. Then you need to take the created csvs and charts in order to populate an InDesign template and from there make pdfs. As
of time of writing (October 2015) the InDesign work has to be done on an Apple computer because of how the csvs are written. For the sake of example I'll assume you're running build.sh on prodgateway-vh and are building
the InDesign bits locally.

- scp the generated report/ directory from your user directory on prodgateway-vh to your analytics dir on your local machine (for this you're only really interested in directories that contain the subdir "print", so only get those if you like)
- scp the generated indesign_merge_mac_*.csv files (the number depends on how many countries per csv you setup in the generate_indesign_merge_csv_for_mac.R script) to your local analytics dir 
- get the InDesign template and all its dependencies by copying the whole T:/Country Reports/v.GB22 directory (some directory other than your analytics dir)
- open the template (GBIF-Country-Report-Template.indd) in InDesign, and make sure fonts and images look good (are linked and loaded properly)
- in InDesign open the Data Merge window with Windows -> Utilities -> Data Merge
- upper left button on that window let's you pick your merge source - choose the first of the indesign_merge_mac_*.csv files (ignore warnings that you'll have to replace placeholders)
- then click bottom right button of Data Merge window and then OK to start the merge
- get a coffee, maybe two
- once the merge is completed switch to the merged tab (probably called GBIF-Country-Report-Template-1)
- now add a table of contents using the window Layout -> Table of Contents. This dictates the names of the final country report pdfs. From the Other Styles window choose either CountryName (if you want the full country name as it appears at the top of the country report, e.g. Denmark.pdf) or CountryCode (if you want just the code, e.g. DK.pdf). To use the script that distributes the country reports back into the report structure for later upload to gbif.org, you want the CountryCode version. (Note that the InDesign template has a placeholder at the end of the very first paragraph that is in the Paragraph Style CountryCode, which is what is used for this process. That style makes the text 6pt and white, so should be invisible.) Make sure the Generate PDF Bookmarks checkbox is selected. Place the table of contents off the visible pages (off to the right has worked best for me).
- now you can export the merged InDesign document as a pdf. File -> Export... and then choose PDF (Print) as the type. Name it whatever you like and make sure Include Bookmarks and Hyperlinks is checked. This takes a deceptively long time where you get no feedback from InDesign. Check the filesize of the pdf you are creating and you'll see it grow over 5-10 minutes of exporting.
- next comes Adobe Acrobat to split the big pdf into individual countries. Open Acrobat (not just Acrobat Reader) and open the pdf you just created
- from the menu icons on the right choose Organize Pages, then at the top choose Split, and in the Split By dropdown choose Top level bookmarks. Click Output options and pick a destination for the split files, and make sure "Use bookmark names for file names" is selected. Then press the Split button and your pdfs will be created reasonably quickly.
- repeat that process until you've done all the indesign_merge_mac_*.csv files, and you therefore have all the country reports as pdfs
- now scp your pdfs directory back to prodgateway-vh and put it in your analytics directory (at same level as report)
- on prodgateway-vh run the distribute-country-pdfs.sh from the analytics dir to copy the pdfs into their respective country directories
- now you've got all the content needed to update gbif.org/analytics
- I suggest making a copy of the reports dir called reports_for_export, which you can then clean up a bit as follows:
  - if you ran the -runHtml step you have unneeded html which you can delete with ```find reports_for_export/ -name '*.html' -exec -rm {} \;```
  - you don't want the print directories and pdfs so again ```find reports_for_export/ -name 'print' -exec -rm -Rf {} \;```
- scp the reports_for_export to root@prodapps-vh:/var/www/html/drupal/sites/default/files/gbif_analytics_new
- ```chown -R apache.apache /var/www/html/drupal/sites/default/files/gbif_analytics_new```
- ```mv gbif_analytics gbif_analytics_old && mv gbif_analytics_new gbif_analytics```
- then make a backup of the old analytics, just in case something gets spotted in the new run that looks wrong, but make the backup in /root (e.g. ```cd /root``` and ```tar czvf gbif_analytics_old.tar.gz /var/www/html/drupal/sites/default/files/gbif_analytics_old``` and then delete the old dir to free up space (```rm -Rf /var/www/html/drupal/sites/default/files/gbif_analytics_old```)
- check http://gbif.org/analytics, write an email to staff@gbif.org giving heads up on the new data, and accept the many accolades due your outstanding achievement in the field of excellence!




### Acknowledgements
The work presented here is not new, and builds on ideas already published.  In particular the work of Javier Otegui, Arturo H. Ariño, María A. Encinas, Francisco Pando (http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0055144) was used as inspiration during the first development iteration, and Javier Otegui kindly provided a crash course in R to kickstart the development.  



