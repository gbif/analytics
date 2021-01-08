library(reshape2)
library(plyr)
library(ggplot2) 
source("R/graph/utils.R")
source("R/graph/plot_utils.R")

spe_repatriation <- function(sourceFile, plotsDir) {
  print(paste("Processing repatriation graphs for: ", sourceFile))

  DF <- read.table(sourceFile, header=T, sep=",")
  DF$snapshot <- as.Date(DF$snapshot)  
  DF <- melt(DF, id=c("snapshot"))
  colnames(DF) <- c("snapshot", "origin", "occurrenceCount")
  total <- ddply(DF, .(snapshot), summarize, occurrenceCount=sum(occurrenceCount), .drop=FALSE)
  displayOrder <- c("national", "international")
  DF$origin <- factor(DF$origin, rev(displayOrder))
  palette <- c('#9e9ac8', '#2d004b')
  # don't plot if only a single point
  if (length(unique(DF$snapshot)) > 1 && sum(as.numeric(DF$occurrenceCount)) > 0) {
    generatePlots(
      df=DF,
      totalDf=total, 
      plotsDir=plotsDir,
      targetFilePattern="spe_repatriation", 
      plotTitle="Origin of species records", 
      dataCol="origin", 
      xCol="snapshot", 
      yCol="occurrenceCount", 
      xTitle="Date",
      yTitle="Number of species (in thousands)",
      yFormatter=kilo_formatter,
      legendTitle="Origin", 
      seriesColours=palette, 
      seriesValues=displayOrder,
      seriesTitles=c("national"="From within country", "international"="From other countries")
    )
  }
}
