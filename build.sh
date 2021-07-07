#!/bin/bash -e

registryStatistics="false"
interpretSnapshots="false"
summarizeSnapshots="false"
downloadCsvs="false"
processCsvs="false"
makeFigures="false"
queryDownloads="false"

destination_db="analytics"
snapshot_db="snapshot"

[[ $* =~ (^| )"-registryStatistics"($| ) ]] && registryStatistics="true"
[[ $* =~ (^| )"-interpretSnapshots"($| ) ]] && interpretSnapshots="true"
[[ $* =~ (^| )"-summarizeSnapshots"($| ) ]] && summarizeSnapshots="true"
[[ $* =~ (^| )"-downloadCsvs"($| ) ]] && downloadCsvs="true"
[[ $* =~ (^| )"-processCsvs"($| ) ]] && processCsvs="true"
[[ $* =~ (^| )"-makeFigures"($| ) ]] && makeFigures="true"
[[ $* =~ (^| )"-queryDownloads"($| ) ]] && queryDownloads="true"

export LANG=en_GB.UTF-8

# If Docker isn't used:
# - Arial and Arial Narrow will be required on the machine from which
# the makeFigures command is run. For Linux that means a new dir under
# /usr/share/fonts with the .ttf files from this project's fonts/ dir
# copied in (the provisioning project's Ansible scripts take care of
# this).
# - The /usr/lib64/R/library/extrafontdb dir must be writeable by the
# user running the makeFigures command because font stuff will be
# written there on first load
Rscript="docker run --rm -it -v $PWD:/analytics/ docker.gbif.org/analytics-figures Rscript"
PyScript="docker run --rm -it -v $PWD:/analytics/ docker.gbif.org/analytics-figures python3"
# Set the permissions correctly afterwards
RscriptChown="docker run --rm -it -v $PWD:/analytics/ docker.gbif.org/analytics-figures chown --recursive --from root:root --reference build.sh report"

log () {
  echo $(tput setaf 3)$(date '+%Y-%m-%d %H:%M:%S ')$(tput setaf 11)$1$(tput sgr0)
}

if [ $registryStatistics == "true" ]; then
  log 'Removing the registry statistics output folder'
  rm -Rf registry-report/
  mkdir -p registry-report/dataset registry-report/organization

  log 'Running Registry Statistics stage'
  ./registry/datasets.sh
  ./registry/organizations.sh

  log '###################################'
  log 'INTERPRET SNAPSHOTS STAGE COMPLETED'
  log '###################################'
else
  log 'Skipping Registry Statistics stage (add -registryStatistics to command to run it)'
fi

if [ $interpretSnapshots == "true" ]; then
  log 'Running Interpret Snapshots stages (import and geo/taxonomy table creation)'
  log 'HBase stage: build_raw_scripts.sh'
  ./hive/normalize/build_raw_scripts.sh
  log 'HBase stage: create_tmp_raw_tables.sh'
  ./hive/normalize/create_tmp_raw_tables.sh
  log 'HBase stage: create_tmp_interp_tables.sh'
  ./hive/normalize/create_tmp_interp_tables.sh
  log 'HBase stage: create_occurrence_tables.sh'
  ./hive/normalize/create_occurrence_tables.sh

  log '###################################'
  log 'INTERPRET SNAPSHOTS STAGE COMPLETED'
  log '###################################'
else
  log 'Skipping Interpret Snapshots stage (add -interpretSnapshots to command to run it)'
fi

if [ $summarizeSnapshots == "true" ]; then
  log 'Running Summarize Snapshots stages (Existing tables are replaced)'
  prepare_file="hive/process/prepare.q"
  ./hive/process/build_prepare_script.sh $prepare_file
  log 'Hive stage: Union all snapshots into a table'
  hive --hiveconf DB="$destination_db" --hiveconf SNAPSHOT_DB="$snapshot_db" -f $prepare_file

  log 'Hive stage: Process occ_kingdom_basisOfRecord.q'
  hive --hiveconf DB="$destination_db" -f hive/process/occ_kingdom_basisOfRecord.q
  log 'Hive stage: Process occ_dayCollected.q'
  hive --hiveconf DB="$destination_db" -f hive/process/occ_dayCollected.q
  log 'Hive stage: Process occ_yearCollected.q'
  hive --hiveconf DB="$destination_db" -f hive/process/occ_yearCollected.q
  log 'Hive stage: Process occ_complete_v2.q'
  hive --hiveconf DB="$destination_db" -f hive/process/occ_complete_v2.q
  log 'Hive stage: Process occ_cells.q'
  hive --hiveconf DB="$destination_db" -f hive/process/occ_cells.q
  log 'Hive stage: Process occ_repatriation.q'
  hive --hiveconf DB="$destination_db" -f hive/process/occ_repatriation.q
  log 'Hive stage: Process occ_density.q'
  hive --hiveconf DB="$destination_db" -f hive/process/occ_density.q

  log 'Hive stage: Process spe_kingdom.q'
  hive --hiveconf DB="$destination_db" -f hive/process/spe_kingdom.q
  log 'Hive stage: Process spe_dayCollected.q'
  hive --hiveconf DB="$destination_db" -f hive/process/spe_dayCollected.q
  log 'Hive stage: Process spe_yearCollected.q'
  hive --hiveconf DB="$destination_db" -f hive/process/spe_yearCollected.q
  log 'Hive stage: Process spe_repatriation.q'
  hive --hiveconf DB="$destination_db" -f hive/process/spe_repatriation.q

  log 'Hive stage: Process totals.q'
  hive --hiveconf DB="$destination_db" -f hive/process/totals.q

  log '###################################'
  log 'SUMMARIZE SNAPSHOTS STAGE COMPLETED'
  log '###################################'
else
  log 'Skipping Summarize Snapshots stage (add -summarizeSnapshots to command to run it)'
fi

if [ $downloadCsvs == "true" ]; then
  log 'Running Download CSVs stages'
  log 'Downloading the CSVs from HDFS (existing data are overwritten)'
  rm -fr hadoop
  mkdir hadoop

  # Download in parallel (much faster), but list the file as a way to check it was retrieved.
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_country_kingdom_basisofrecord hadoop/occ_country_kingdom_basisOfRecord.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishercountry_kingdom_basisofrecord hadoop/occ_publisherCountry_kingdom_basisOfRecord.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_gbifregion_kingdom_basisofrecord hadoop/occ_gbifRegion_kingdom_basisOfRecord.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishergbifregion_kingdom_basisofrecord hadoop/occ_publisherGbifRegion_kingdom_basisOfRecord.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_kingdom_basisofrecord hadoop/occ_kingdom_basisOfRecord.csv
  wait
  ls -l hadoop/occ_country_kingdom_basisOfRecord.csv
  ls -l hadoop/occ_publisherCountry_kingdom_basisOfRecord.csv
  ls -l hadoop/occ_gbifRegion_kingdom_basisOfRecord.csv
  ls -l hadoop/occ_publisherGbifRegion_kingdom_basisOfRecord.csv
  ls -l hadoop/occ_kingdom_basisOfRecord.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_country_daycollected hadoop/occ_country_dayCollected.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishercountry_daycollected hadoop/occ_publisherCountry_dayCollected.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_gbifregion_daycollected hadoop/occ_gbifRegion_dayCollected.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishergbifregion_daycollected hadoop/occ_publisherGbifRegion_dayCollected.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_daycollected hadoop/occ_dayCollected.csv
  wait
  ls -l hadoop/occ_country_dayCollected.csv
  ls -l hadoop/occ_publisherCountry_dayCollected.csv
  ls -l hadoop/occ_gbifRegion_dayCollected.csv
  ls -l hadoop/occ_publisherGbifRegion_dayCollected.csv
  ls -l hadoop/occ_dayCollected.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_country_yearcollected hadoop/occ_country_yearCollected.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishercountry_yearcollected hadoop/occ_publisherCountry_yearCollected.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_gbifregion_yearcollected hadoop/occ_gbifRegion_yearCollected.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishergbifregion_yearcollected hadoop/occ_publisherGbifRegion_yearCollected.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_yearcollected hadoop/occ_yearCollected.csv
  wait
  ls -l hadoop/occ_country_yearCollected.csv
  ls -l hadoop/occ_publisherCountry_yearCollected.csv
  ls -l hadoop/occ_gbifRegion_yearCollected.csv
  ls -l hadoop/occ_publisherGbifRegion_yearCollected.csv
  ls -l hadoop/occ_yearCollected.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_country_complete hadoop/occ_country_complete.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishercountry_complete hadoop/occ_publisherCountry_complete.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_gbifregion_complete hadoop/occ_gbifRegion_complete.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishergbifregion_complete hadoop/occ_publisherGbifRegion_complete.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_complete hadoop/occ_complete.csv
  wait
  ls -l hadoop/occ_country_complete.csv
  ls -l hadoop/occ_publisherCountry_complete.csv
  ls -l hadoop/occ_gbifRegion_complete.csv
  ls -l hadoop/occ_publisherGbifRegion_complete.csv
  ls -l hadoop/occ_complete.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_country_repatriation hadoop/occ_country_repatriation.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishercountry_repatriation hadoop/occ_publisherCountry_repatriation.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_gbifregion_repatriation hadoop/occ_gbifRegion_repatriation.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishergbifregion_repatriation hadoop/occ_publisherGbifRegion_repatriation.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_repatriation hadoop/occ_repatriation.csv
  wait
  ls -l hadoop/occ_country_repatriation.csv
  ls -l hadoop/occ_publisherCountry_repatriation.csv
  ls -l hadoop/occ_gbifRegion_repatriation.csv
  ls -l hadoop/occ_publisherGbifRegion_repatriation.csv
  ls -l hadoop/occ_repatriation.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_country hadoop/occ_country.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishercountry hadoop/occ_publisherCountry.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_gbifregion hadoop/occ_gbifRegion.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishergbifregion hadoop/occ_publisherGbifRegion.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ hadoop/occ.csv
  wait
  ls -l hadoop/occ_country.csv
  ls -l hadoop/occ_publisherCountry.csv
  ls -l hadoop/occ_gbifRegion.csv
  ls -l hadoop/occ_publisherGbifRegion.csv
  ls -l hadoop/occ.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_country_cell_one_deg hadoop/occ_country_cell_one_deg.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishercountry_cell_one_deg hadoop/occ_publisherCountry_cell_one_deg.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_gbifregion_cell_one_deg hadoop/occ_gbifRegion_cell_one_deg.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishergbifregion_cell_one_deg hadoop/occ_publisherGbifRegion_cell_one_deg.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_cell_one_deg hadoop/occ_cell_one_deg.csv
  wait
  ls -l hadoop/occ_country_cell_one_deg.csv
  ls -l hadoop/occ_publisherCountry_cell_one_deg.csv
  ls -l hadoop/occ_gbifRegion_cell_one_deg.csv
  ls -l hadoop/occ_publisherGbifRegion_cell_one_deg.csv
  ls -l hadoop/occ_cell_one_deg.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_country_cell_point_one_deg hadoop/occ_country_cell_point_one_deg.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishercountry_cell_point_one_deg hadoop/occ_publisherCountry_cell_point_one_deg.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_gbifregion_cell_point_one_deg hadoop/occ_gbifRegion_cell_point_one_deg.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishergbifregion_cell_point_one_deg hadoop/occ_publisherGbifRegion_cell_point_one_deg.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_cell_point_one_deg hadoop/occ_cell_point_one_deg.csv
  wait
  ls -l hadoop/occ_country_cell_point_one_deg.csv
  ls -l hadoop/occ_publisherCountry_cell_point_one_deg.csv
  ls -l hadoop/occ_gbifRegion_cell_point_one_deg.csv
  ls -l hadoop/occ_publisherGbifRegion_cell_point_one_deg.csv
  ls -l hadoop/occ_cell_point_one_deg.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_country_cell_half_deg hadoop/occ_country_cell_half_deg.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishercountry_cell_half_deg hadoop/occ_publisherCountry_cell_half_deg.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_gbifregion_cell_half_deg hadoop/occ_gbifRegion_cell_half_deg.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishergbifregion_cell_half_deg hadoop/occ_publisherGbifRegion_cell_half_deg.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_cell_half_deg hadoop/occ_cell_half_deg.csv
  wait
  ls -l hadoop/occ_country_cell_half_deg.csv
  ls -l hadoop/occ_publisherCountry_cell_half_deg.csv
  ls -l hadoop/occ_gbifRegion_cell_half_deg.csv
  ls -l hadoop/occ_publisherGbifRegion_cell_half_deg.csv
  ls -l hadoop/occ_cell_half_deg.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_density_country_point_one_deg hadoop/occ_density_country_point_one_deg.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_density_publishercountry_point_one_deg hadoop/occ_density_publisherCountry_point_one_deg.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_density_gbifregion_point_one_deg hadoop/occ_density_gbifRegion_point_one_deg.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_density_publishergbifregion_point_one_deg hadoop/occ_density_publisherGbifRegion_point_one_deg.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_density_point_one_deg hadoop/occ_density_point_one_deg.csv
  wait
  ls -l hadoop/occ_density_country_point_one_deg.csv
  ls -l hadoop/occ_density_publisherCountry_point_one_deg.csv
  ls -l hadoop/occ_density_gbifRegion_point_one_deg.csv
  ls -l hadoop/occ_density_publisherGbifRegion_point_one_deg.csv
  ls -l hadoop/occ_density_point_one_deg.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_country_kingdom hadoop/spe_country_kingdom.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_publishercountry_kingdom hadoop/spe_publisherCountry_kingdom.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_gbifregion_kingdom hadoop/spe_gbifRegion_kingdom.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_publishergbifregion_kingdom hadoop/spe_publisherGbifRegion_kingdom.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_kingdom hadoop/spe_kingdom.csv
  wait
  ls -l hadoop/spe_country_kingdom.csv
  ls -l hadoop/spe_publisherCountry_kingdom.csv
  ls -l hadoop/spe_gbifRegion_kingdom.csv
  ls -l hadoop/spe_publisherGbifRegion_kingdom.csv
  ls -l hadoop/spe_kingdom.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_country_kingdom_observation hadoop/spe_country_kingdom_observation.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_publishercountry_kingdom_observation hadoop/spe_publisherCountry_kingdom_observation.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_gbifregion_kingdom_observation hadoop/spe_gbifRegion_kingdom_observation.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_publishergbifregion_kingdom_observation hadoop/spe_publisherGbifRegion_kingdom_observation.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_kingdom_observation hadoop/spe_kingdom_observation.csv
  wait
  ls -l hadoop/spe_country_kingdom_observation.csv
  ls -l hadoop/spe_publisherCountry_kingdom_observation.csv
  ls -l hadoop/spe_gbifRegion_kingdom_observation.csv
  ls -l hadoop/spe_publisherGbifRegion_kingdom_observation.csv
  ls -l hadoop/spe_kingdom_observation.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_country_kingdom_specimen hadoop/spe_country_kingdom_specimen.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_publishercountry_kingdom_specimen hadoop/spe_publisherCountry_kingdom_specimen.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_gbifregion_kingdom_specimen hadoop/spe_gbifRegion_kingdom_specimen.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_publishergbifregion_kingdom_specimen hadoop/spe_publisherGbifRegion_kingdom_specimen.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_kingdom_specimen hadoop/spe_kingdom_specimen.csv
  wait
  ls -l hadoop/spe_country_kingdom_specimen.csv
  ls -l hadoop/spe_publisherCountry_kingdom_specimen.csv
  ls -l hadoop/spe_gbifRegion_kingdom_specimen.csv
  ls -l hadoop/spe_publisherGbifRegion_kingdom_specimen.csv
  ls -l hadoop/spe_kingdom_specimen.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_country_daycollected hadoop/spe_country_dayCollected.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_publishercountry_daycollected hadoop/spe_publisherCountry_dayCollected.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_gbifregion_daycollected hadoop/spe_gbifRegion_dayCollected.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_publishergbifregion_daycollected hadoop/spe_publisherGbifRegion_dayCollected.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_daycollected hadoop/spe_dayCollected.csv
  wait
  ls -l hadoop/spe_country_dayCollected.csv
  ls -l hadoop/spe_publisherCountry_dayCollected.csv
  ls -l hadoop/spe_gbifRegion_dayCollected.csv
  ls -l hadoop/spe_publisherGbifRegion_dayCollected.csv
  ls -l hadoop/spe_dayCollected.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_country_yearcollected hadoop/spe_country_yearCollected.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_publishercountry_yearcollected hadoop/spe_publisherCountry_yearCollected.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_gbifregion_yearcollected hadoop/spe_gbifRegion_yearCollected.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_publishergbifregion_yearcollected hadoop/spe_publisherGbifRegion_yearCollected.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_yearcollected hadoop/spe_yearCollected.csv
  wait
  ls -l hadoop/spe_country_yearCollected.csv
  ls -l hadoop/spe_publisherCountry_yearCollected.csv
  ls -l hadoop/spe_gbifRegion_yearCollected.csv
  ls -l hadoop/spe_publisherGbifRegion_yearCollected.csv
  ls -l hadoop/spe_yearCollected.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_country_repatriation hadoop/spe_country_repatriation.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_publishercountry_repatriation hadoop/spe_publisherCountry_repatriation.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_gbifregion_repatriation hadoop/spe_gbifRegion_repatriation.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_publishergbifregion_repatriation hadoop/spe_publisherGbifRegion_repatriation.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_repatriation hadoop/spe_repatriation.csv
  wait
  ls -l hadoop/spe_country_repatriation.csv
  ls -l hadoop/spe_publisherCountry_repatriation.csv
  ls -l hadoop/spe_gbifRegion_repatriation.csv
  ls -l hadoop/spe_publisherGbifRegion_repatriation.csv
  ls -l hadoop/spe_repatriation.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_country hadoop/spe_country.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_publishercountry hadoop/spe_publisherCountry.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_gbifregion hadoop/spe_gbifRegion.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_publishergbifregion hadoop/spe_publisherGbifRegion.csv &
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe hadoop/spe.csv
  wait
  ls -l hadoop/spe_country.csv
  ls -l hadoop/spe_publisherCountry.csv
  ls -l hadoop/spe_gbifRegion.csv
  ls -l hadoop/spe_publisherGbifRegion.csv
  ls -l hadoop/spe.csv

  log '#############################'
  log 'DOWNLOAD CSVS STAGE COMPLETED'
  log '#############################'
else
  log 'Skipping Download CSVs stage (add -downloadCsvs to command to run it)'
fi

if [ $processCsvs == "true" ]; then
  log 'Removing the reports output folder'
  rm -fr report

  log 'Preparing the CSVs'
  log 'R script occ_kingdomBasisOfRecord.R'
  $Rscript R/csv/occ_kingdomBasisOfRecord.R
  log 'R script occ_dayCollected.R'
  $Rscript R/csv/occ_dayCollected.R
  log 'R script occ_yearCollected.R'
  $Rscript R/csv/occ_yearCollected.R
  log 'R script occ_complete.R'
  $Rscript R/csv/occ_complete.R
  log 'R script occ_repatriation.R'
  $Rscript R/csv/occ_repatriation.R
  log 'R script occ.R'
  $Rscript R/csv/occ.R
  log 'R script occ_cells.R'
  $Rscript R/csv/occ_cells.R
  log 'Python script occ_density.py'
  $PyScript R/geotiff/occ_density.py

  log 'R script spe_kingdom.R'
  $Rscript R/csv/spe_kingdom.R
  log 'R script spe_dayCollected.R'
  $Rscript R/csv/spe_dayCollected.R
  log 'R script spe_yearCollected.R'
  $Rscript R/csv/spe_yearCollected.R
  log 'R script spe_repatriation.R'
  $Rscript R/csv/spe_repatriation.R
  log 'R script spe.R'
  $Rscript R/csv/spe.R
  $RscriptChown

  log '############################'
  log 'PROCESS CSVS STAGE COMPLETED'
  log '############################'
else
  log 'Skipping Process CSVs stage (add -processCsvs to command to run it)'
fi

if [ $makeFigures == "true" ]; then
  log 'Generating the figures'
  $Rscript R/report.R
  $RscriptChown

  # Font embedding, disabled as we aren't making PDF figures.
  # Mac specific, typical font defaults
  # ./embed_dingbats_mac.sh report /System/Library/Fonts
  # linux specific, paths as per readme
  # ./embed_dingbats_linux.sh report /usr/share/fonts
  log '#######################'
  log 'FIGURES STAGE COMPLETED'
  log '#######################'
else
  log 'Skipping create figures stage (add -makeFigures to command to run it)'
fi

if [ $queryDownloads == "true" ]; then
  log 'Removing the download reports output folder'
  rm -Rf report/download/csv/
  mkdir -p report/download/csv/

  log 'Downloading download statistics from PostgreSQL'
  ./sql/summarizeDownloads.sh report/download/csv/

  log '######################################'
  log 'DOWNLOAD DOWNLOAD STATISTICS COMPLETED'
  log '######################################'
else
  log 'Skipping download download statistics stage (add -queryDownloads to command to run it)'
fi
