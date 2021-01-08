library(reshape2)
library(plyr)
library(ggplot2) 
source("R/graph/utils.R")

occ_dayCollected <- function(sourceFile, targetDir) {
  print(paste("Processing day collected graphs for: ", sourceFile))
  dir.create(targetDir, showWarnings=F)  
  
  DF <- read.table(sourceFile, header=T, sep=",")
  DF <- DF[DF$snapshot %in% temporalFacetSnapshots,]
  
  p1 <- ggplot(arrange(DF,day,occurrenceCount), aes(x=day,y=occurrenceCount)) + 
    geom_area(fill="#ff7f00", alpha=0.7) +
    facet_grid(snapshot~.) +
    scale_x_continuous(expand=c(0,0),limits=c(1,366),breaks=c(1,32,60,91,121,152,182,213,244,274,305,335,366)) +
    ylab("Number of occurrences (in millions)") +
    xlab("Day of year") +
    scale_y_continuous(label = mill_formatter) +
    ggtitle("Number of occurrences per day of year") 
  
  #png
  webFile <- paste(targetDir, "occ_dayCollected.png", sep="/")
  savePng(file=webFile, plot=p1)

  #svg
  svgFile <- paste(targetDir, "occ_dayCollected.svg", sep="/")
  saveSvg(file=svgFile, plot=p1)
}
