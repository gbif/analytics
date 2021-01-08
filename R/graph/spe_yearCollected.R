library(reshape2)
library(plyr)
library(ggplot2) 
source("R/graph/utils.R")

spe_yearCollected <- function(sourceFile, targetDir) {
  print(paste("Processing year collected graphs for: ", sourceFile))
  dir.create(targetDir, showWarnings=F)  
  
  DF <- read.table(sourceFile, header=T, sep=",")
  DF <- DF[DF$snapshot %in% temporalFacetSnapshots,]
  DF <- DF[DF$year >= minPlotYear,]
  
  p1 <- ggplot(arrange(DF,snapshot,year), aes(x=year,y=speciesCount)) + 
           geom_area(fill="#2d004b", alpha=0.7) +
           scale_x_continuous(expand=c(0,0),breaks=seq(minPlotYear,2020,10)) +
           facet_grid(snapshot~.) +
           ylab("Number of species (in thousands)") +
           xlab("Year") +
           scale_y_continuous(label = kilo_formatter) +
           ggtitle("Number of species per year") 
  
  #png
  webFile <- paste(targetDir, "spe_yearCollected.png", sep="/")
  savePng(file=webFile, plot=p1)

  #svg
  svgFile <- paste(targetDir, "spe_yearCollected.svg", sep="/")
  saveSvg(file=svgFile, plot=p1)
}