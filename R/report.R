source("R/graph/occ_kingdomBasisOfRecord.R")
source("R/graph/occ_dayCollected.R")
source("R/graph/occ_yearCollected.R")
source("R/graph/occ_basisOfRecordComplete.R")
source("R/graph/occ_complete.R")
source("R/graph/occ_repatriation.R")
source("R/graph/occ_cells.R")
source("R/graph/occ.R")
source("R/graph/spe_kingdom.R")
source("R/graph/spe_dayCollected.R")
source("R/graph/spe_yearCollected.R")
source("R/graph/spe_repatriation.R")
source("R/graph/spe.R")
source("R/graph/occ_density.R")

library(doParallel)

if (Sys.info()[['sysname']] == "Windows") {
    print("Cannot run in parallel on Windows.")
    cores <- 1
} else {
    cores <- detectCores()
    print(sprintf("Will run in parallel on %d cores.", cores))
}

path <- "report"
globalAndRegionPath <- c("report/global", "report/gbifRegion")
# useful to speed up development, to only use the global directory
# path <- "report/global"
# path <- "report/country/DE"
# path <- "report/country/FR"
# path <- "report/country/ZW/publishedBy"

csvs <- list.files(path=path, pattern="occ_kingdom_basisOfRecord.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
mclapply(csvs, function(csv) {
    plotsDir <- gsub("/csv", "", dirname(csv))
    occ_kingdomBasisOfRecord(sourceFile=csv, plotsDir=plotsDir)
}, mc.cores = cores)

csvs <- list.files(path=path, pattern="spe_kingdom.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
mclapply(csvs, function(csv) {
  plotsDir <- gsub("/csv", "", dirname(csv))
  spe_kingdom(sourceFile=csv,
              plotsDir=plotsDir,
              targetFilePattern='spe_kingdom',
              palette = c("#005397", "#b2df8a", "#984ea3", "#FFFFE0"),
              title='Number of species having occurrence records accessible through GBIF over time')
}, mc.cores = cores)

csvs <- list.files(path=path, pattern="spe_kingdom_observation.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
mclapply(csvs, function(csv) {
  plotsDir <- gsub("/csv", "", dirname(csv))
  spe_kingdom(sourceFile=csv,
              plotsDir=plotsDir,
              targetFilePattern='spe_kingdom_observation',
              palette = c("#005397", "#b2df8a", "#984ea3", "#FFFFE0"),
              title='Number of species from observation records accessible through GBIF over time')
}, mc.cores = cores)

csvs <- list.files(path=path, pattern="spe_kingdom_specimen.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
mclapply(csvs, function(csv) {
  plotsDir <- gsub("/csv", "", dirname(csv))
  spe_kingdom(sourceFile=csv,
              plotsDir=plotsDir,
              targetFilePattern='spe_kingdom_specimen',
              palette = c("#005397", "#b2df8a", "#984ea3", "#FFFFE0"),
              title='Number of species having specimen records accessible through GBIF over time')
}, mc.cores = cores)

csvs <- list.files(path=path, pattern="occ_complete.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
mclapply(csvs, function(csv) {
  plotsDir <- gsub("/csv", "", dirname(csv))
  occ_complete(sourceFile=csv, plotsDir=plotsDir)
}, mc.cores = cores)

csvs <- list.files(path=path, pattern="occ_repatriation.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
mclapply(csvs, function(csv) {
  plotsDir <- gsub("/csv", "", dirname(csv))
  occ_repatriation(sourceFile=csv, plotsDir=plotsDir)
}, mc.cores = cores)

csvs <- list.files(path=path, pattern="spe_repatriation.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
mclapply(csvs, function(csv) {
  plotsDir <- gsub("/csv", "", dirname(csv))
  spe_repatriation(sourceFile=csv, plotsDir=plotsDir)
}, mc.cores = cores)

# TODO: could be rewritten to use plot_utils, but requires new method
csvs <- list.files(path=path, pattern="occ_dayCollected.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
mclapply(csvs, function(csv) {
  figureDir <- gsub("csv","figure", dirname(csv))
  occ_dayCollected(sourceFile=csv, targetDir=figureDir)
}, mc.cores = cores)

# TODO: could be rewritten to use plot_utils, but requires new method
csvs <- list.files(path=path, pattern="occ_yearCollected.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
mclapply(csvs, function(csv) {
  figureDir <- gsub("csv","figure", dirname(csv))
  occ_yearCollected(sourceFile=csv, targetDir=figureDir)
}, mc.cores = cores)

# TODO: could be rewritten to use plot_utils, but requires new method
csvs <- list.files(path=path, pattern="spe_dayCollected.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
mclapply(csvs, function(csv) {
  figureDir <- gsub("csv","figure", dirname(csv))
  spe_dayCollected(sourceFile=csv, targetDir=figureDir)
}, mc.cores = cores)

# TODO: could be rewritten to use plot_utils, but requires new method
csvs <- list.files(path=path, pattern="spe_yearCollected.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
mclapply(csvs, function(csv) {
  figureDir <- gsub("csv","figure", dirname(csv))
  spe_yearCollected(sourceFile=csv, targetDir=figureDir)
}, mc.cores = cores)

csvs <- list.files(path=path, pattern="occ_cell_one_deg.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
mclapply(csvs, function(csv) {
  plotsDir <- gsub("/csv", "", dirname(csv))
  occ_cells(
    sourceFile=csv,
    plotsDir=plotsDir,
    targetFilePattern="occ_cells_one_deg",
    title = "Number of species with presence in cells (1 degree)",
    palette <- c("#a6611a", "#dfc27d", "#f5f5f5", "#80cdc1", "#018571"))
}, mc.cores = cores)

csvs <- list.files(path=path, pattern="occ_cell_point_one_deg.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
mclapply(csvs, function(csv) {
  plotsDir <- gsub("/csv", "", dirname(csv))
  occ_cells(
    sourceFile=csv,
    plotsDir=plotsDir,
    targetFilePattern="occ_cells_point_one_deg",
    title = "Number of species with presence in cells (0.1 degree)",
    palette <- c("#a6611a", "#dfc27d", "#f5f5f5", "#80cdc1", "#018571"))
}, mc.cores = cores)

csvs <- list.files(path=path, pattern="occ_cell_half_deg.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
mclapply(csvs, function(csv) {
  plotsDir <- gsub("/csv", "", dirname(csv))
  occ_cells(
    sourceFile=csv,
    plotsDir=plotsDir,
    targetFilePattern="occ_cells_half_deg",
    title = "Number of species with presence in cells (0.5 degree)",
    palette <- c("#a6611a", "#dfc27d", "#f5f5f5", "#80cdc1", "#018571"))
}, mc.cores = cores)

# For the density maps, only global and GBIF region figures are made
csvs <- list.files(path=globalAndRegionPath, pattern="occ_density_point_one_deg.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
mclapply(csvs, function(csv) {
  plotsDir <- gsub("/csv", "", dirname(csv))
  occ_density(
    sourceFile=csv,
    plotsDir=plotsDir,
    targetFilePattern="occ_density_point_one_deg_%s")
}, mc.cores = cores)

# unused
# csvs <- list.files(path=path, pattern="occ_basisOfRecord_complete.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
# mclapply(csvs, function(csv) {
#   figureDir <- gsub("csv","figure", dirname(csv))
#   occ_basisOfRecordComplete(sourceFile=csv, targetDir=figureDir)
# }, mc.cores = cores)
