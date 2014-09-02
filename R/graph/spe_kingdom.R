library(reshape2)
library(plyr)
library(ggplot2) 
source("R/graph/utils.R")

spe_kingdom <- function(sourceFile, targetDir, targetFile, palette, title) {
  print(paste("Processing species richness by kingdom graphs for: ", sourceFile))
  dir.create(targetDir, showWarnings=F)  
  
  DF <- read.table(sourceFile, header=T, sep=",")
  DF$snapshot <- as.Date(DF$snapshot)
  DF$kingdom <- sapply(DF$kingdom, interpKingdom)
  DF <- populate_factors(DF, c("kingdom"))
  
  # group by kingdom, totaling the counts
  kingdom <- ddply(DF, .(snapshot,kingdom), summarize, speciesCount=sum(speciesCount), .drop=FALSE)
  
  total <- ddply(DF, .(snapshot), summarize, speciesCount=sum(speciesCount), .drop=FALSE)
  displayOrder = c("Animalia", "Plantae", "Other", "Unknown")

  # rev() here priorities the first one highest
  kingdom$kingdom <- factor(kingdom$kingdom, rev(displayOrder))
  
  # don't plot if only a single point
  if (length(unique(kingdom$snapshot)) > 1 && sum(kingdom$speciesCount) > 0) {
    p1 <- 
      ggplot(kingdom, aes(x=snapshot,y=speciesCount)) +
      scale_x_date() +
      # unknown bug: displayOrder works in RStudio here, but not on command line
      geom_area(aes(fill=kingdom, group = kingdom, order = factor(kingdom,c("Animalia", "Plantae", "Other", "Unknown"))), position='stack', linetype=0, alpha = 0.7 ) +
      geom_line(data = total, colour = "black", size=1) +
      geom_point(data = total, colour = "black") +
      theme(legend.justification=c(0,1), legend.position=c(0.05,0.95)) + 
      # reversed to match the priotization above
      scale_fill_manual(values=rev(palette)) +
      ylab("Number of species (in thousands)") +
      xlab("Date") +
      scale_y_continuous(label = kilo_formatter) + 
      ggtitle(title) 
    #ggsave(filename=paste(targetDir, targetFile, sep="/"), plot=p1, width=8, height=6 )
    savePng(p1, paste(targetDir, targetFile, sep="/"))
  }
}