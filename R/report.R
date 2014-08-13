source("R/graph/occ_kingdomBasisOfRecord.R")
source("R/graph/occ_dayCollected.R")
source("R/graph/occ_yearCollected.R")
source("R/graph/occ_basisOfRecordComplete.R")
source("R/graph/occ_complete.R")
source("R/graph/occ_repatriation.R")
source("R/graph/occ_cells.R")
source("R/graph/spe_kingdom.R")
source("R/graph/spe_dayCollected.R")
source("R/graph/spe_yearCollected.R")
source("R/graph/spe_repatriation.R")

path <- "report"
# useful to speed up development, to only use the global directory
#path <- "report/country/DK"
path <- "report/global"
#path <- "report/country/AD/publishedBy"

csvs <- list.files(path=path, pattern="occ_kingdom_basisOfRecord.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
for (csv in csvs) {
  figureDir <- gsub("csv","figure", dirname(csv))
  occ_kingdomBasisOfRecord(sourceFile=csv, targetDir=figureDir) 
}

csvs <- list.files(path=path, pattern="occ_dayCollected.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
for (csv in csvs) {
  figureDir <- gsub("csv","figure", dirname(csv))
  occ_dayCollected(sourceFile=csv, targetDir=figureDir) 
}

csvs <- list.files(path=path, pattern="occ_yearCollected.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
for (csv in csvs) {
  figureDir <- gsub("csv","figure", dirname(csv))
  occ_yearCollected(sourceFile=csv, targetDir=figureDir) 
}

csvs <- list.files(path=path, pattern="spe_kingdom.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
for (csv in csvs) {
  figureDir <- gsub("csv","figure", dirname(csv))
  spe_kingdom(sourceFile=csv, 
              targetDir=figureDir, 
              targetFile='spe_kingdom.png',
              #palette=c("#542788", "#998ec3", "#f1a340", "#FFFFE0"), 
              palette = c("#005397", "#b2df8a", "#984ea3", "#FFFFE0"),
              title='Number of species having occurrence records accessible through GBIF over time')
}

csvs <- list.files(path=path, pattern="spe_kingdom_observation.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
for (csv in csvs) {
  figureDir <- gsub("csv","figure", dirname(csv))
  spe_kingdom(sourceFile=csv, 
              targetDir=figureDir, 
              targetFile='spe_kingdom_observation.png',
              #palette=c("#053061", "#4393c3", "#d6604d", "#FFFFE0"), 
              palette = c("#005397", "#b2df8a", "#984ea3", "#FFFFE0"),
              title='Number of species from observation records accessible through GBIF over time')
}

csvs <- list.files(path=path, pattern="spe_kingdom_specimen.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
for (csv in csvs) {
  figureDir <- gsub("csv","figure", dirname(csv))
  spe_kingdom(sourceFile=csv, 
              targetDir=figureDir, 
              targetFile='spe_kingdom_specimen.png',
              #palette=c("#00441b", "#5aae61", "#c2a5cf", "#FFFFE0"), 
              palette = c("#005397", "#b2df8a", "#984ea3", "#FFFFE0"),
              title='Number of species having specimen records accessible through GBIF over time')
}


#csvs <- list.files(path=path, pattern="occ_basisOfRecord_complete.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
#for (csv in csvs) {
#  figureDir <- gsub("csv","figure", dirname(csv))
#  occ_basisOfRecordComplete(sourceFile=csv, targetDir=figureDir) 
#}

csvs <- list.files(path=path, pattern="occ_complete.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
for (csv in csvs) {
  figureDir <- gsub("csv","figure", dirname(csv))
  occ_complete(sourceFile=csv, targetDir=figureDir) 
}

csvs <- list.files(path=path, pattern="occ_repatriation.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
for (csv in csvs) {
  figureDir <- gsub("csv","figure", dirname(csv))
  occ_repatriation(sourceFile=csv, targetDir=figureDir) 
}

csvs <- list.files(path=path, pattern="spe_dayCollected.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
for (csv in csvs) {
  figureDir <- gsub("csv","figure", dirname(csv))
  spe_dayCollected(sourceFile=csv, targetDir=figureDir) 
}

csvs <- list.files(path=path, pattern="spe_yearCollected.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
for (csv in csvs) {
  figureDir <- gsub("csv","figure", dirname(csv))
  spe_yearCollected(sourceFile=csv, targetDir=figureDir) 
}

csvs <- list.files(path=path, pattern="spe_repatriation.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
for (csv in csvs) {
  figureDir <- gsub("csv","figure", dirname(csv))
  spe_repatriation(sourceFile=csv, targetDir=figureDir) 
}

csvs <- list.files(path=path, pattern="occ_cell_one_deg.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
for (csv in csvs) {
  figureDir <- gsub("csv","figure", dirname(csv))
  occ_cells(
    sourceFile=csv, 
    targetDir=figureDir,
    title = "Number of species with presence in cells (1 degree)",
    targetFile = "occ_cells_one_deg.png",
    #palette = c("#a6611a","#dfc27d","#f6e8c3","#80cdc1","#018571"))
    palette <- c("#a6611a", "#dfc27d", "#f5f5f5", "#80cdc1", "#018571")) 
}

csvs <- list.files(path=path, pattern="occ_cell_point_one_deg.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
for (csv in csvs) {
  figureDir <- gsub("csv","figure", dirname(csv))
  occ_cells(
    sourceFile=csv, 
    targetDir=figureDir,
    title = "Number of species with presence in cells (0.1 degree)",
    targetFile = "occ_cells_point_one_deg.png",
    #palette = c("#542788","#998ec3","#d8daeb","#f1a340","#b35806")) 
    palette <- c("#a6611a", "#dfc27d", "#f5f5f5", "#80cdc1", "#018571"))
}

csvs <- list.files(path=path, pattern="occ_cell_half_deg.csv", full.names=TRUE, recursive=TRUE, include.dirs=TRUE)
for (csv in csvs) {
  figureDir <- gsub("csv","figure", dirname(csv))
  occ_cells(
    sourceFile=csv, 
    targetDir=figureDir,
    title = "Number of species with presence in cells (0.5 degree)",
    targetFile = "occ_cells_half_deg.png",
    #palette = c("#313695","#74add1","#abd9e9","#fdae61","#f46d43")) 
    palette <- c("#a6611a", "#dfc27d", "#f5f5f5", "#80cdc1", "#018571"))
}