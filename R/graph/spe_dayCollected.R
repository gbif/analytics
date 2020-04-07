library(reshape2)
library(plyr)
library(ggplot2) 
source("R/graph/utils.R")

spe_dayCollected <- function(sourceFile, targetDir) {
  print(paste("Processing day collected graphs for: ", sourceFile))
  dir.create(targetDir, showWarnings=F)  
  
  DF <- read.table(sourceFile, header=T, sep=",")
  DF <- DF[DF$snapshot %in% temporalFacetSnapshots,]
  
  p1 <- ggplot(arrange(DF,day,speciesCount), aes(x=day,y=speciesCount)) + 
    geom_area(fill="#2d004b", alpha=0.7) +
    facet_grid(snapshot~.) +
    ylab("Number of species (in thousands)") +
    xlab("Day of year") +
    scale_y_continuous(label = kilo_formatter) + 
    ggtitle("Number of species per day of year") 
  
  #png
  webFile <- paste(targetDir, "spe_dayCollected.png", sep="/")
  savePng(file=webFile, plot=p1)

  #svg
  svgFile <- paste(targetDir, "spe_dayCollected.svg", sep="/")
  saveSvg(file=svgFile, plot=p1)
}
