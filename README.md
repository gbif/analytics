##Analytics

> The project site for http://analytics.gbif-uat.org which is currently under development.

### What are the analytics?
GBIF have started development towards capturing various metrics to enable monitoring of the data trends.
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
- R scripts that use moustache templating to produce the current static site




