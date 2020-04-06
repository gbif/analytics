runHbase="false"
runHive="false"
runHadoop="false"
runPrepare="false"
runFigures="false"

destination_db="analytics"
snapshot_db="snapshot"

[[ $* =~ (^| )"-runHbase"($| ) ]] && runHbase="true"
[[ $* =~ (^| )"-runHive"($| ) ]] && runHive="true"
[[ $* =~ (^| )"-runHadoop"($| ) ]] && runHadoop="true"
[[ $* =~ (^| )"-runPrepare"($| ) ]] && runPrepare="true"
[[ $* =~ (^| )"-runFigures"($| ) ]] && runFigures="true"

export LANG=en_GB.UTF-8

alias Rscript="docker run --rm -it -v $PWD:/analytics/ docker.gbif.org/analytics-figures Rscript"

log () {
  echo $(tput setaf 3)$(date '+%Y-%m-%d %H:%M:%S ')$(tput setaf 11)$1$(tput sgr0)
}

if [ $runHbase == "true" ];then
  log 'Running HBase stages (import and geo/taxonomy table creation)'
  log 'HBase stage: build_raw_scripts.sh'
  ./hive/normalize/build_raw_scripts.sh
  log 'HBase stage: create_tmp_raw_tables.sh'
  ./hive/normalize/create_tmp_raw_tables.sh
  log 'HBase stage: create_tmp_interp_tables.sh'
  ./hive/normalize/create_tmp_interp_tables.sh
  log 'HBase stage: create_occurrence_tables.sh'
  ./hive/normalize/create_occurrence_tables.sh

  log '#####################'
  log 'HBASE STAGE COMPLETED'
  log '#####################'
else
  log 'Skipping hbase stage (add -runHbase to command to run it)'
fi

if [ $runHive == "true" ];then
  log 'Running Hive stages (Existing tables are replaced)'
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
  log 'Hive stage: Process occ_complete.q'
  hive --hiveconf DB="$destination_db" -f hive/process/occ_complete.q
  log 'Hive stage: Process occ_complete_v2.q'
  hive --hiveconf DB="$destination_db" -f hive/process/occ_complete_v2.q
  log 'Hive stage: Process occ_cells.q'
  hive --hiveconf DB="$destination_db" -f hive/process/occ_cells.q

  log 'Hive stage: Process spe_kingdom.q'
  hive --hiveconf DB="$destination_db" -f hive/process/spe_kingdom.q
  log 'Hive stage: Process spe_dayCollected.q'
  hive --hiveconf DB="$destination_db" -f hive/process/spe_dayCollected.q
  log 'Hive stage: Process spe_yearCollected.q'
  hive --hiveconf DB="$destination_db" -f hive/process/spe_yearCollected.q

  log 'Hive stage: Process repatriation.q'
  hive --hiveconf DB="$destination_db" -f hive/process/repatriation.q
  log '####################'
  log 'HIVE STAGE COMPLETED'
  log '####################'
else
  log 'Skipping hive stage (add -runHive to command to run it)'
fi

if [ $runHadoop == "true" ];then
  log 'Running Hadoop stages'
  log 'Downloading the CSVs from Hadoop (Existing data are overwritten)'
  rm -fr hadoop
  mkdir hadoop
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_country_kingdom_basisofrecord hadoop/occ_country_kingdom_basisOfRecord.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishercountry_kingdom_basisofrecord hadoop/occ_publisherCountry_kingdom_basisOfRecord.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_kingdom_basisofrecord hadoop/occ_kingdom_basisOfRecord.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_country_daycollected hadoop/occ_country_dayCollected.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishercountry_daycollected hadoop/occ_publisherCountry_dayCollected.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_daycollected hadoop/occ_dayCollected.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_country_yearcollected hadoop/occ_country_yearCollected.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishercountry_yearcollected hadoop/occ_publisherCountry_yearCollected.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_yearcollected hadoop/occ_yearCollected.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_country_complete hadoop/occ_country_complete.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishercountry_complete hadoop/occ_publisherCountry_complete.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_complete hadoop/occ_complete.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_country_repatriation hadoop/occ_country_repatriation.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishercountry_repatriation hadoop/occ_publisherCountry_repatriation.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_repatriation hadoop/occ_repatriation.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_country_cell_one_deg hadoop/occ_country_cell_one_deg.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishercountry_cell_one_deg hadoop/occ_publisherCountry_cell_one_deg.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_cell_one_deg hadoop/occ_cell_one_deg.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_country_cell_point_one_deg hadoop/occ_country_cell_point_one_deg.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishercountry_cell_point_one_deg hadoop/occ_publisherCountry_cell_point_one_deg.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_cell_point_one_deg hadoop/occ_cell_point_one_deg.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_country_cell_half_deg hadoop/occ_country_cell_half_deg.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_publishercountry_cell_half_deg hadoop/occ_publisherCountry_cell_half_deg.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/occ_cell_half_deg hadoop/occ_cell_half_deg.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_country_kingdom hadoop/spe_country_kingdom.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_publishercountry_kingdom hadoop/spe_publisherCountry_kingdom.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_kingdom hadoop/spe_kingdom.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_country_kingdom_observation hadoop/spe_country_kingdom_observation.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_publishercountry_kingdom_observation hadoop/spe_publisherCountry_kingdom_observation.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_kingdom_observation hadoop/spe_kingdom_observation.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_country_kingdom_specimen hadoop/spe_country_kingdom_specimen.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_publishercountry_kingdom_specimen hadoop/spe_publisherCountry_kingdom_specimen.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_kingdom_specimen hadoop/spe_kingdom_specimen.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_country_daycollected hadoop/spe_country_dayCollected.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_publishercountry_daycollected hadoop/spe_publisherCountry_dayCollected.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_daycollected hadoop/spe_dayCollected.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_country_yearcollected hadoop/spe_country_yearCollected.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_publishercountry_yearcollected hadoop/spe_publisherCountry_yearCollected.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_yearcollected hadoop/spe_yearCollected.csv

  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_country_repatriation hadoop/spe_country_repatriation.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_publishercountry_repatriation hadoop/spe_publisherCountry_repatriation.csv
  hdfs dfs -getmerge /user/hive/warehouse/"$destination_db".db/spe_repatriation hadoop/spe_repatriation.csv
  log '######################'
  log 'HADOOP STAGE COMPLETED'
  log '######################'
else
  log 'Skipping Hadoop copy stage (add -runHadoop to command to run it)'
fi

if [ $runPrepare == "true" ];then
  log 'Removing the reports output folder'
  rm -fr report

  log 'Preparing the CSVs'
  log 'R script occ_kingdomBasisOfRecord.R'
  Rscript R/csv/occ_kingdomBasisOfRecord.R
  log 'R script occ_dayCollected.R'
  Rscript R/csv/occ_dayCollected.R
  log 'R script occ_yearCollected.R'
  Rscript R/csv/occ_yearCollected.R
  log 'R script occ_complete.R'
  Rscript R/csv/occ_complete.R
  log 'R script occ_repatriation.R'
  Rscript R/csv/occ_repatriation.R
  log 'R script occ_cells.R'
  Rscript R/csv/occ_cells.R
  log 'R script spe_kingdom.R'
  Rscript R/csv/spe_kingdom.R
  log 'R script spe_dayCollected.R'
  Rscript R/csv/spe_dayCollected.R
  log 'R script spe_yearCollected.R'
  Rscript R/csv/spe_yearCollected.R
  log 'R script spe_repatriation.R'
  Rscript R/csv/spe_repatriation.R

  log '#######################'
  log 'PREPARE STAGE COMPLETED'
  log '#######################'
else
  log 'Skipping prepare CSV stage (add -runPrepare to command to run it)'
fi

if [ $runFigures == "true" ];then
  log 'Generating the figures'
  Rscript R/report.R

  # Font embedding, disabled as we aren't making PDF figures.
  # Mac specific, typical font defaults
  # ./embed_dingbats_mac.sh report /System/Library/Fonts
  # linux specific, paths as per readme
  # ./embed_dingbats_linux.sh report /usr/share/fonts
  log '#######################'
  log 'FIGURES STAGE COMPLETED'
  log '#######################'
else
  log 'Skipping create figures stage (add -runFigures to command to run it)'
fi
