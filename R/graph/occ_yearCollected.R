library(reshape2)
library(plyr)
library(ggplot2) 
source("R/graph/utils.R")

occ_yearCollected <- function(sourceFile, targetDir) {
  print(paste("Processing year collected graphs for: ", sourceFile))
  dir.create(targetDir, showWarnings=F)  
  
  DF <- read.table(sourceFile, header=T, sep=",")
  DF <- DF[DF$snapshot %in% temporalFacetSnapshots,]
  DF <- DF[DF$year >= minPlotYear,]
  
  p1 <- ggplot(arrange(DF,snapshot,year), aes(x=year,y=occurrenceCount)) + 
           geom_area(fill="#ff7f00", alpha=0.7) +
           facet_grid(snapshot~.) +
           ylab("Number of occurrences (in millions)") +
           xlab("Year") +
           scale_y_continuous(label = mill_formatter) +
          ggtitle("Number of occurrences per year") 
  
  #png
  webFile <- paste(targetDir, "occ_yearCollected.png", sep="/")
  savePng(file=webFile, plot=p1)

  #svg
  svgFile <- paste(targetDir, "occ_yearCollected.svg", sep="/")
  saveSvg(file=svgFile, plot=p1)
}