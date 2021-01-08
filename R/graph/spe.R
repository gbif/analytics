library(reshape2)
library(plyr)
library(ggplot2)
source("R/graph/utils.R")
source("R/graph/plot_utils.R")

spe <- function(sourceFile, plotsDir) {
  print(paste("Processing species totals graphs for: ", sourceFile))

  DF <- read.table(sourceFile, header=T, sep=",")
  DF$snapshot <- as.Date(DF$snapshot)
  colnames(DF) <- c("snapshot", "speciesCount")
  generateBasicPlots(
    df=DF,
    plotsDir=plotsDir,
    targetFilePattern="spe",
    plotTitle="Number of species having occurrence records accessible through GBIF over time",
    xCol="snapshot",
    yCol="speciesCount",
    xTitle="Date",
    yTitle="Number of species (in thousands)",
    yFormatter=mill_formatter,
    colour='#005397',
  )
}
