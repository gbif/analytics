Rscript="docker run --rm -it -v $PWD:/analytics/ -v $(realpath hadoop/):/analytics/hadoop/ docker.gbif.org/analytics-figures Rscript"
PyScript="docker run --rm -it -v $PWD:/analytics/ -v $(realpath hadoop/):/analytics/hadoop/ docker.gbif.org/analytics-figures python3"
# Set the permissions correctly afterwards
RscriptChown="docker run --rm -it -v $PWD:/analytics/ docker.gbif.org/analytics-figures chown --recursive --from root:root --reference build.sh report"

echo 'Preparing the CSVs'
echo 'R script occ_kingdomBasisOfRecord.R'
$Rscript R/csv/occ_kingdomBasisOfRecord.R
echo 'R script occ_dayCollected.R'
$Rscript R/csv/occ_dayCollected.R
echo 'R script occ_yearCollected.R'
$Rscript R/csv/occ_yearCollected.R
echo 'R script occ_complete.R'
$Rscript R/csv/occ_complete.R
echo 'R script occ_repatriation.R'
$Rscript R/csv/occ_repatriation.R
echo 'R script occ.R'
$Rscript R/csv/occ.R
echo 'R script occ_cells.R'
$Rscript R/csv/occ_cells.R
echo 'Python script occ_density.py'
$PyScript R/geotiff/occ_density.py

echo 'R script spe_kingdom.R'
$Rscript R/csv/spe_kingdom.R
echo 'R script spe_dayCollected.R'
$Rscript R/csv/spe_dayCollected.R
echo 'R script spe_yearCollected.R'
$Rscript R/csv/spe_yearCollected.R
echo 'R script spe_repatriation.R'
$Rscript R/csv/spe_repatriation.R
echo 'R script spe.R'
$Rscript R/csv/spe.R
$RscriptChown

echo '############################'
echo 'PROCESS CSVS STAGE COMPLETED'
echo '############################'

echo 'Generating the figures'
$Rscript R/report.R
$RscriptChown

echo 'Copying placeholders'
country_reports/copy_placeholders.sh

