#!/bin/bash -e

TRINO_SERVER=$1
export TRINO_PASSWORD=$2
KUBE_CONFIG=$3

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
Rscript="docker run --rm -it -v $PWD:/analytics/ -v $(realpath hadoop/):/analytics/hadoop/ docker.gbif.org/analytics-figures Rscript"
PyScript="docker run --rm -it -v $PWD:/analytics/ -v $(realpath hadoop/):/analytics/hadoop/ docker.gbif.org/analytics-figures python3"
# Set the permissions correctly afterwards
RscriptChown="docker run --rm -it -v $PWD:/analytics/ docker.gbif.org/analytics-figures chown --recursive --from root:root --reference build.sh report"

log () {
  echo $(tput setaf 3)$(date '+%Y-%m-%d %H:%M:%S ')$(tput setaf 11)$1$(tput sgr0)
}

if [ $registryStatistics == "true" ]; then
  log 'Removing the registry statistics output folder'
  rm -Rf registry-report/
  mkdir -p registry-report/dataset registry-report/organization registry-report/node

  log 'Running Registry Statistics stage'
  ./registry/datasets.sh
  ./registry/organizations.sh
  ./registry/nodes.sh

  log '###################################'
  log 'REGISTRY STATISTICS STAGE COMPLETED'
  log '###################################'
else
  log 'Skipping Registry Statistics stage (add -registryStatistics to command to run it)'
fi

if [ $interpretSnapshots == "true" ]; then
  log 'Running Interpret Snapshots stages (import and geo/taxonomy table creation)'
  ./trino/import/create_tables.sh $destination_db "$TRINO_SERVER" "$TRINO_PASSWORD" "$KUBE_CONFIG"

  log '###################################'
  log 'INTERPRET SNAPSHOTS STAGE COMPLETED'
  log '###################################'
else
  log 'Skipping Interpret Snapshots stage (add -interpretSnapshots to command to run it)'
fi

if [ $summarizeSnapshots == "true" ]; then
   log 'Running Summarize Snapshots stages (Existing tables are replaced)'
    prepare_file="trino/process/prepare.q"
    ./trino/process/build_prepare_script.sh $prepare_file $destination_db
    log 'Hive stage: Union all snapshots into a table'
    /usr/local/gbif/trino.jar --insecure --debug --server "$TRINO_SERVER" --catalog=hive \
      --schema="$destination_db" --session="hive.compression_codec=SNAPPY" --execute="$(<$prepare_file)" --user gbif --password

    files=$(find trino/process -name '*.q')
    for f in $files
    do
      log "Executing $f"
      /usr/local/gbif/trino.jar --insecure --debug --server "$TRINO_SERVER" --catalog=hive \
      --schema="$destination_db" --session="hive.compression_codec=NONE" --execute="$(<"$f")" --user gbif --password
    done

    log '###################################'
    log 'SUMMARIZE SNAPSHOTS STAGE COMPLETED'
    log '###################################'
else
     log 'Skipping Summarize Snapshots stage (add -summarizeSnapshots to command to run it)'
fi

if [ $downloadCsvs == "true" ]; then
  log 'Running Download CSVs stages'
  log 'Downloading the CSVs from HDFS (existing data are overwritten)'

  ./trino/download_csvs.sh "$destination_db"

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

  log 'Copying placeholders'
  country_reports/copy_placeholders.sh

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
