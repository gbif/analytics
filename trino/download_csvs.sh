#!/bin/bash -e

DB=$1

SOURCE_DB=/stackable/warehouse/$DB.db
DESTINATION_DIR=hadoop

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# This might be a symlink to somewhere with more disk space
mkdir -p $DESTINATION_DIR
find $DESTINATION_DIR/ -type f -delete

# Download in parallel (much faster), but list the file as a way to check it was retrieved.
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_country_kingdom_basisofrecord "$DESTINATION_DIR"/occ_country_kingdom_basisOfRecord.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_publishercountry_kingdom_basisofrecord "$DESTINATION_DIR"/occ_publisherCountry_kingdom_basisOfRecord.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_gbifregion_kingdom_basisofrecord "$DESTINATION_DIR"/occ_gbifRegion_kingdom_basisOfRecord.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_publishergbifregion_kingdom_basisofrecord "$DESTINATION_DIR"/occ_publisherGbifRegion_kingdom_basisOfRecord.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_kingdom_basisofrecord "$DESTINATION_DIR"/occ_kingdom_basisOfRecord.csv
wait
ls -l "$DESTINATION_DIR"/occ_country_kingdom_basisOfRecord.csv
ls -l "$DESTINATION_DIR"/occ_publisherCountry_kingdom_basisOfRecord.csv
ls -l "$DESTINATION_DIR"/occ_gbifRegion_kingdom_basisOfRecord.csv
ls -l "$DESTINATION_DIR"/occ_publisherGbifRegion_kingdom_basisOfRecord.csv
ls -l "$DESTINATION_DIR"/occ_kingdom_basisOfRecord.csv

/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_country_daycollected "$DESTINATION_DIR"/occ_country_dayCollected.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_publishercountry_daycollected "$DESTINATION_DIR"/occ_publisherCountry_dayCollected.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_gbifregion_daycollected "$DESTINATION_DIR"/occ_gbifRegion_dayCollected.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_publishergbifregion_daycollected "$DESTINATION_DIR"/occ_publisherGbifRegion_dayCollected.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_daycollected "$DESTINATION_DIR"/occ_dayCollected.csv
wait
ls -l "$DESTINATION_DIR"/occ_country_dayCollected.csv
ls -l "$DESTINATION_DIR"/occ_publisherCountry_dayCollected.csv
ls -l "$DESTINATION_DIR"/occ_gbifRegion_dayCollected.csv
ls -l "$DESTINATION_DIR"/occ_publisherGbifRegion_dayCollected.csv
ls -l "$DESTINATION_DIR"/occ_dayCollected.csv

/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_country_yearcollected "$DESTINATION_DIR"/occ_country_yearCollected.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_publishercountry_yearcollected "$DESTINATION_DIR"/occ_publisherCountry_yearCollected.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_gbifregion_yearcollected "$DESTINATION_DIR"/occ_gbifRegion_yearCollected.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_publishergbifregion_yearcollected "$DESTINATION_DIR"/occ_publisherGbifRegion_yearCollected.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_yearcollected "$DESTINATION_DIR"/occ_yearCollected.csv
wait
ls -l "$DESTINATION_DIR"/occ_country_yearCollected.csv
ls -l "$DESTINATION_DIR"/occ_publisherCountry_yearCollected.csv
ls -l "$DESTINATION_DIR"/occ_gbifRegion_yearCollected.csv
ls -l "$DESTINATION_DIR"/occ_publisherGbifRegion_yearCollected.csv
ls -l "$DESTINATION_DIR"/occ_yearCollected.csv

/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_country_complete "$DESTINATION_DIR"/occ_country_complete.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_publishercountry_complete "$DESTINATION_DIR"/occ_publisherCountry_complete.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_gbifregion_complete "$DESTINATION_DIR"/occ_gbifRegion_complete.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_publishergbifregion_complete "$DESTINATION_DIR"/occ_publisherGbifRegion_complete.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_complete "$DESTINATION_DIR"/occ_complete.csv
wait
ls -l "$DESTINATION_DIR"/occ_country_complete.csv
ls -l "$DESTINATION_DIR"/occ_publisherCountry_complete.csv
ls -l "$DESTINATION_DIR"/occ_gbifRegion_complete.csv
ls -l "$DESTINATION_DIR"/occ_publisherGbifRegion_complete.csv
ls -l "$DESTINATION_DIR"/occ_complete.csv

/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_country_repatriation "$DESTINATION_DIR"/occ_country_repatriation.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_publishercountry_repatriation "$DESTINATION_DIR"/occ_publisherCountry_repatriation.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_gbifregion_repatriation "$DESTINATION_DIR"/occ_gbifRegion_repatriation.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_publishergbifregion_repatriation "$DESTINATION_DIR"/occ_publisherGbifRegion_repatriation.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_repatriation "$DESTINATION_DIR"/occ_repatriation.csv
wait
ls -l "$DESTINATION_DIR"/occ_country_repatriation.csv
ls -l "$DESTINATION_DIR"/occ_publisherCountry_repatriation.csv
ls -l "$DESTINATION_DIR"/occ_gbifRegion_repatriation.csv
ls -l "$DESTINATION_DIR"/occ_publisherGbifRegion_repatriation.csv
ls -l "$DESTINATION_DIR"/occ_repatriation.csv

/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_country "$DESTINATION_DIR"/occ_country.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_publishercountry "$DESTINATION_DIR"/occ_publisherCountry.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_gbifregion "$DESTINATION_DIR"/occ_gbifRegion.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_publishergbifregion "$DESTINATION_DIR"/occ_publisherGbifRegion.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ "$DESTINATION_DIR"/occ.csv
wait
ls -l "$DESTINATION_DIR"/occ_country.csv
ls -l "$DESTINATION_DIR"/occ_publisherCountry.csv
ls -l "$DESTINATION_DIR"/occ_gbifRegion.csv
ls -l "$DESTINATION_DIR"/occ_publisherGbifRegion.csv
ls -l "$DESTINATION_DIR"/occ.csv

/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_country_cell_one_deg "$DESTINATION_DIR"/occ_country_cell_one_deg.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_publishercountry_cell_one_deg "$DESTINATION_DIR"/occ_publisherCountry_cell_one_deg.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_gbifregion_cell_one_deg "$DESTINATION_DIR"/occ_gbifRegion_cell_one_deg.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_publishergbifregion_cell_one_deg "$DESTINATION_DIR"/occ_publisherGbifRegion_cell_one_deg.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_cell_one_deg "$DESTINATION_DIR"/occ_cell_one_deg.csv
wait
ls -l "$DESTINATION_DIR"/occ_country_cell_one_deg.csv
ls -l "$DESTINATION_DIR"/occ_publisherCountry_cell_one_deg.csv
ls -l "$DESTINATION_DIR"/occ_gbifRegion_cell_one_deg.csv
ls -l "$DESTINATION_DIR"/occ_publisherGbifRegion_cell_one_deg.csv
ls -l "$DESTINATION_DIR"/occ_cell_one_deg.csv
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_country_cell_point_one_deg "$DESTINATION_DIR"/occ_country_cell_point_one_deg.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_publishercountry_cell_point_one_deg "$DESTINATION_DIR"/occ_publisherCountry_cell_point_one_deg.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_gbifregion_cell_point_one_deg "$DESTINATION_DIR"/occ_gbifRegion_cell_point_one_deg.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_publishergbifregion_cell_point_one_deg "$DESTINATION_DIR"/occ_publisherGbifRegion_cell_point_one_deg.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_cell_point_one_deg "$DESTINATION_DIR"/occ_cell_point_one_deg.csv
wait
ls -l "$DESTINATION_DIR"/occ_country_cell_point_one_deg.csv
ls -l "$DESTINATION_DIR"/occ_publisherCountry_cell_point_one_deg.csv
ls -l "$DESTINATION_DIR"/occ_gbifRegion_cell_point_one_deg.csv
ls -l "$DESTINATION_DIR"/occ_publisherGbifRegion_cell_point_one_deg.csv
ls -l "$DESTINATION_DIR"/occ_cell_point_one_deg.csv

/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_country_cell_half_deg "$DESTINATION_DIR"/occ_country_cell_half_deg.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_publishercountry_cell_half_deg "$DESTINATION_DIR"/occ_publisherCountry_cell_half_deg.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_gbifregion_cell_half_deg "$DESTINATION_DIR"/occ_gbifRegion_cell_half_deg.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_publishergbifregion_cell_half_deg "$DESTINATION_DIR"/occ_publisherGbifRegion_cell_half_deg.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_cell_half_deg "$DESTINATION_DIR"/occ_cell_half_deg.csv
wait
ls -l "$DESTINATION_DIR"/occ_country_cell_half_deg.csv
ls -l "$DESTINATION_DIR"/occ_publisherCountry_cell_half_deg.csv
ls -l "$DESTINATION_DIR"/occ_gbifRegion_cell_half_deg.csv
ls -l "$DESTINATION_DIR"/occ_publisherGbifRegion_cell_half_deg.csv
ls -l "$DESTINATION_DIR"/occ_cell_half_deg.csv

/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_density_country_point_one_deg "$DESTINATION_DIR"/occ_density_country_point_one_deg.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_density_publishercountry_point_one_deg "$DESTINATION_DIR"/occ_density_publisherCountry_point_one_deg.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_density_gbifregion_point_one_deg "$DESTINATION_DIR"/occ_density_gbifRegion_point_one_deg.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_density_publishergbifregion_point_one_deg "$DESTINATION_DIR"/occ_density_publisherGbifRegion_point_one_deg.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/occ_density_point_one_deg "$DESTINATION_DIR"/occ_density_point_one_deg.csv
wait
ls -l "$DESTINATION_DIR"/occ_density_country_point_one_deg.csv
ls -l "$DESTINATION_DIR"/occ_density_publisherCountry_point_one_deg.csv
ls -l "$DESTINATION_DIR"/occ_density_gbifRegion_point_one_deg.csv
ls -l "$DESTINATION_DIR"/occ_density_publisherGbifRegion_point_one_deg.csv
ls -l "$DESTINATION_DIR"/occ_density_point_one_deg.csv

/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_country_kingdom "$DESTINATION_DIR"/spe_country_kingdom.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_publishercountry_kingdom "$DESTINATION_DIR"/spe_publisherCountry_kingdom.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_gbifregion_kingdom "$DESTINATION_DIR"/spe_gbifRegion_kingdom.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_publishergbifregion_kingdom "$DESTINATION_DIR"/spe_publisherGbifRegion_kingdom.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_kingdom "$DESTINATION_DIR"/spe_kingdom.csv
wait
ls -l "$DESTINATION_DIR"/spe_country_kingdom.csv
ls -l "$DESTINATION_DIR"/spe_publisherCountry_kingdom.csv
ls -l "$DESTINATION_DIR"/spe_gbifRegion_kingdom.csv
ls -l "$DESTINATION_DIR"/spe_publisherGbifRegion_kingdom.csv
ls -l "$DESTINATION_DIR"/spe_kingdom.csv

/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_country_kingdom_observation "$DESTINATION_DIR"/spe_country_kingdom_observation.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_publishercountry_kingdom_observation "$DESTINATION_DIR"/spe_publisherCountry_kingdom_observation.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_gbifregion_kingdom_observation "$DESTINATION_DIR"/spe_gbifRegion_kingdom_observation.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_publishergbifregion_kingdom_observation "$DESTINATION_DIR"/spe_publisherGbifRegion_kingdom_observation.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_kingdom_observation "$DESTINATION_DIR"/spe_kingdom_observation.csv
wait
ls -l "$DESTINATION_DIR"/spe_country_kingdom_observation.csv
ls -l "$DESTINATION_DIR"/spe_publisherCountry_kingdom_observation.csv
ls -l "$DESTINATION_DIR"/spe_gbifRegion_kingdom_observation.csv
ls -l "$DESTINATION_DIR"/spe_publisherGbifRegion_kingdom_observation.csv
ls -l "$DESTINATION_DIR"/spe_kingdom_observation.csv

/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_country_kingdom_specimen "$DESTINATION_DIR"/spe_country_kingdom_specimen.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_publishercountry_kingdom_specimen "$DESTINATION_DIR"/spe_publisherCountry_kingdom_specimen.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_gbifregion_kingdom_specimen "$DESTINATION_DIR"/spe_gbifRegion_kingdom_specimen.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_publishergbifregion_kingdom_specimen "$DESTINATION_DIR"/spe_publisherGbifRegion_kingdom_specimen.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_kingdom_specimen "$DESTINATION_DIR"/spe_kingdom_specimen.csv
wait
ls -l "$DESTINATION_DIR"/spe_country_kingdom_specimen.csv
ls -l "$DESTINATION_DIR"/spe_publisherCountry_kingdom_specimen.csv
ls -l "$DESTINATION_DIR"/spe_gbifRegion_kingdom_specimen.csv
ls -l "$DESTINATION_DIR"/spe_publisherGbifRegion_kingdom_specimen.csv
ls -l "$DESTINATION_DIR"/spe_kingdom_specimen.csv

/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_country_daycollected "$DESTINATION_DIR"/spe_country_dayCollected.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_publishercountry_daycollected "$DESTINATION_DIR"/spe_publisherCountry_dayCollected.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_gbifregion_daycollected "$DESTINATION_DIR"/spe_gbifRegion_dayCollected.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_publishergbifregion_daycollected "$DESTINATION_DIR"/spe_publisherGbifRegion_dayCollected.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_daycollected "$DESTINATION_DIR"/spe_dayCollected.csv
wait
ls -l "$DESTINATION_DIR"/spe_country_dayCollected.csv
ls -l "$DESTINATION_DIR"/spe_publisherCountry_dayCollected.csv
ls -l "$DESTINATION_DIR"/spe_gbifRegion_dayCollected.csv
ls -l "$DESTINATION_DIR"/spe_publisherGbifRegion_dayCollected.csv
ls -l "$DESTINATION_DIR"/spe_dayCollected.csv

/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_country_yearcollected "$DESTINATION_DIR"/spe_country_yearCollected.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_publishercountry_yearcollected "$DESTINATION_DIR"/spe_publisherCountry_yearCollected.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_gbifregion_yearcollected "$DESTINATION_DIR"/spe_gbifRegion_yearCollected.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_publishergbifregion_yearcollected "$DESTINATION_DIR"/spe_publisherGbifRegion_yearCollected.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_yearcollected "$DESTINATION_DIR"/spe_yearCollected.csv
wait
ls -l "$DESTINATION_DIR"/spe_country_yearCollected.csv
ls -l "$DESTINATION_DIR"/spe_publisherCountry_yearCollected.csv
ls -l "$DESTINATION_DIR"/spe_gbifRegion_yearCollected.csv
ls -l "$DESTINATION_DIR"/spe_publisherGbifRegion_yearCollected.csv
ls -l "$DESTINATION_DIR"/spe_yearCollected.csv

/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_country_repatriation "$DESTINATION_DIR"/spe_country_repatriation.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_publishercountry_repatriation "$DESTINATION_DIR"/spe_publisherCountry_repatriation.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_gbifregion_repatriation "$DESTINATION_DIR"/spe_gbifRegion_repatriation.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_publishergbifregion_repatriation "$DESTINATION_DIR"/spe_publisherGbifRegion_repatriation.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_repatriation "$DESTINATION_DIR"/spe_repatriation.csv
wait
ls -l "$DESTINATION_DIR"/spe_country_repatriation.csv
ls -l "$DESTINATION_DIR"/spe_publisherCountry_repatriation.csv
ls -l "$DESTINATION_DIR"/spe_gbifRegion_repatriation.csv
ls -l "$DESTINATION_DIR"/spe_publisherGbifRegion_repatriation.csv
ls -l "$DESTINATION_DIR"/spe_repatriation.csv

/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_country "$DESTINATION_DIR"/spe_country.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_publishercountry "$DESTINATION_DIR"/spe_publisherCountry.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_gbifregion "$DESTINATION_DIR"/spe_gbifRegion.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe_publishergbifregion "$DESTINATION_DIR"/spe_publisherGbifRegion.csv &
/home/stackable/hadoop-3.3.4/bin/hdfs dfs -getmerge "$SOURCE_DB"/spe "$DESTINATION_DIR"/spe.csv
wait
ls -l "$DESTINATION_DIR"/spe_country.csv
ls -l "$DESTINATION_DIR"/spe_publisherCountry.csv
ls -l "$DESTINATION_DIR"/spe_gbifRegion.csv
ls -l "$DESTINATION_DIR"/spe_publisherGbifRegion.csv
ls -l "$DESTINATION_DIR"/spe.csv
