library(reshape2)
library(plyr)
library(ggplot2) 
source("R/graph/utils.R")

spe_repatriation <- function(sourceFile, targetDir) {
  print(paste("Processing repatriation graphs for: ", sourceFile))
  dir.create(targetDir, showWarnings=F)  
  
  DF <- read.table(sourceFile, header=T, sep=",")
  DF$snapshot <- as.Date(DF$snapshot)  
  DF <- melt(DF, id=c("snapshot"))
  colnames(DF) <- c("snapshot", "status", "count")
  total <- ddply(DF, .(snapshot), summarize, count=sum(count))
  displayOrder <- c("national", "international")
  DF$status <- factor(DF$status, rev(displayOrder))
  p1 <- ggplot(DF, aes(x=snapshot,y=count)) + 
           scale_x_date() +
           # unknown bug: displayOrder works in RStudio here, but not on command line
           geom_area(aes(fill=status, group = status, order = factor(status,c("national", "international"))), position='stack', linetype=0, alpha=0.7 ) +
           ylab("Number of species (in thousands)") +
           xlab("Date") +
           geom_line(data = total, colour = "black", size=1) +
           geom_point(data = total, colour = "black") +        
           scale_fill_manual(values=c('#9e9ac8', '#2d004b')) +
           scale_y_continuous(label = kilo_formatter) +
          ggtitle("Number of species repatriated")
  
  #ggsave(filename=paste(targetDir, "occ_yearCollected.png", sep="/"), plot=p1, width=8, height=6 )
  savePng(p1, paste(targetDir, "spe_repatriation.png", sep="/"))
}
