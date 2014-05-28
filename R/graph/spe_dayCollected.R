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
    geom_area(fill="#2d004b", alpha='0.7') +
    facet_grid(snapshot~.) +
    ylab("Number of species (in thousands)") +
    xlab("Day of year") +
    scale_y_continuous(label = kilo_formatter) + 
    ggtitle("Number of species per day of year") 
  
  #ggsave(filename=paste(targetDir, "spe_dayCollected.png", sep="/"), plot=p1, width=8, height=6 )
  savePng(p1, paste(targetDir, "spe_dayCollected.png", sep="/"))
}
