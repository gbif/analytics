library(reshape2)
library(plyr)
library(ggplot2)
source("R/graph/utils.R")
source("R/graph/plot_utils.R")

occ <- function(sourceFile, plotsDir) {
  print(paste("Processing occurrence totals graphs for: ", sourceFile))

  data <- read.table(sourceFile, header=T, sep=",")
  data$snapshot <- as.Date(data$snapshot)
  colnames(data) <- c("snapshot", "occurrenceCount")
  generateBasicPlots(
    df=data,
    plotsDir=plotsDir,
    targetFilePattern="occ",
    plotTitle="Occurrence records accessible through GBIF over time",
    xCol="snapshot",
    yCol="occurrenceCount",
    xTitle="Date",
    yTitle="Number of occurrences (in millions)",
    yFormatter=mill_formatter,
    colour='#005397',
  )
}
