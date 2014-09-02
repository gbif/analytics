library(reshape2)
library(plyr)
library(ggplot2) 
source("R/graph/utils.R")

occ_repatriation <- function(sourceFile, targetDir) {
  print(paste("Processing repatriation graphs for: ", sourceFile))
  dir.create(targetDir, showWarnings=F)  
  
  DF <- read.table(sourceFile, header=T, sep=",")
  DF$snapshot <- as.Date(DF$snapshot)  
  DF <- melt(DF, id=c("snapshot"))
  colnames(DF) <- c("snapshot", "origin", "count")
  total <- ddply(DF, .(snapshot), summarize, count=sum(count), .drop=FALSE)
  displayOrder <- c("national", "international")
  DF$origin <- factor(DF$origin, rev(displayOrder))
  # don't plot if only a single point
  if (length(unique(DF$snapshot)) > 1 && sum(as.numeric(DF$count)) > 0) {
    p1 <- ggplot(DF, aes(x=snapshot,y=count)) + 
             scale_x_date() +
             geom_area(aes(fill=origin, group = origin, order = factor(origin,c("national", "international"))), position='stack', linetype=0, alpha=0.7 ) +
             ylab("Number of occurrences (in millions)") +
             xlab("Date") +
             geom_line(data = total, colour = "black", size=1) +
             geom_point(data = total, colour = "black") +        
             scale_fill_manual(values=c('#ffeda0','#ff7f00'), labels=c("From other countries", "From within country"), name="Origin") +
             scale_y_continuous(label = mill_formatter) +
            ggtitle("Origin of occurrence records") 
    
    #ggsave(filename=paste(targetDir, "occ_yearCollected.png", sep="/"), plot=p1, width=8, height=6 )
    savePng(p1, paste(targetDir, "occ_repatriation.png", sep="/"))
  }
}