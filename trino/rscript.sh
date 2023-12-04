Rscript="docker run --rm -it -v $PWD:/analytics/ -v $(realpath hadoop/):/analytics/hadoop/ docker.gbif.org/analytics-figures Rscript"
PyScript="docker run --rm -it -v $PWD:/analytics/ -v $(realpath hadoop/):/analytics/hadoop/ docker.gbif.org/analytics-figures python3"
# Set the permissions correctly afterwards
RscriptChown="docker run --rm -it -v $PWD:/analytics/ docker.gbif.org/analytics-figures chown --recursive --from root:root --reference build.sh report"

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

log 'Generating the figures'
$Rscript R/report.R
$RscriptChown

log 'Copying placeholders'
country_reports/copy_placeholders.sh

