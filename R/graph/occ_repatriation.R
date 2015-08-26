library(reshape2)
library(plyr)
library(ggplot2) 
source("R/graph/utils.R")
source("R/graph/plot_utils.R")

occ_repatriation <- function(sourceFile, plotsDir) {
  print(paste("Processing repatriation graphs for: ", sourceFile))

  data <- read.table(sourceFile, header=T, sep=",")
  data$snapshot <- as.Date(data$snapshot)  
  data <- melt(data, id=c("snapshot"))
  colnames(data) <- c("snapshot", "origin", "occurrenceCount")
  total <- ddply(data, .(snapshot), summarize, occurrenceCount=sum(occurrenceCount), .drop=FALSE)
  displayOrder <- c("national", "international")
  data$origin <- factor(data$origin, rev(displayOrder))
  palette <- c('#ffeda0','#ff7f00')
  # don't plot if only a single point
  if (length(unique(data$snapshot)) > 1 && sum(as.numeric(data$occurrenceCount)) > 0) {
    generatePlots(
      df=data,
      totalDf=total, 
      plotsDir=plotsDir,
      targetFilePattern="occ_repatriation", 
      plotTitle="Origin of occurrence records", 
      dataCol="origin", 
      xCol="snapshot", 
      yCol="occurrenceCount", 
      xTitle="Date",
      yTitle="Number of occurrences (in millions)", 
      yFormatter=mill_formatter, 
      legendTitle="Origin", 
      seriesColours=rev(palette), 
      seriesValues=rev(displayOrder),
      seriesTitles=c("national"="From within country", "international"="From other countries")
    )
  }
}