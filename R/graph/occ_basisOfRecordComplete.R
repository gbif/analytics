library(reshape2)
library(plyr)
library(ggplot2) 
source("R/graph/utils.R")
############
# UNUSED!
############
occ_basisOfRecordComplete <- function(sourceFile, targetDir) {
  print(paste("Processing basisOfRecordComplete graphs for: ", sourceFile))

  DF <- read.table(sourceFile, header=T, sep=",")
  DF$snapshot <- as.Date(DF$snapshot)
  DF$basisOfRecord <- sapply(DF$basisOfRecord, interpBasisOfRecord)
  DF <- populate_factors(DF, c("kingdom", "basisOfRecord"))
  
  #TODO: should we make UNKNOWN basisOFRecord = incomplete?
  data <- ddply(DF, .(snapshot), summarize, complete=sum(complete), total=sum(total), .drop=FALSE)
  data$incomplete <- data$total - data$complete
  total <- ddply(DF, .(snapshot), summarize, total=sum(total), .drop=FALSE)
  data <- data[c("snapshot", "complete", "incomplete")]
  data <- melt(data, id=c("snapshot"))
  colnames(data) <- c("snapshot", "status", "occurrenceCount")
  
  mill_formatter <- function(x) {
    lab <- x / 1000000
  }  
  
  displayOrder <- c("complete", "incomplete")
  # rev() here priorities the first one highest
  data$status <- factor(data$status, rev(displayOrder))
  cbPalette <- c("#49006a", "#FFFFE0")
    
  # don't plot if only a single point
  if (length(unique(data$snapshot)) > 1 && sum(data$occurrenceCount) > 0) {
    p1 <- 
      ggplot(data, aes(x=snapshot,y=occurrenceCount)) +
      scale_x_date() +
      # unknown bug: displayOrder works in RStudio here, but not on command line
      geom_area(aes(fill=status, group=status, order=factor(status,c("complete", "incomplete"))), position='stack', linetype=0, alpha = 0.7 ) +
      geom_line(data = total, aes(y=total), colour = "#49006a", size=1) +
      geom_point(data = total, aes(y=total), colour = "#49006a") + 
      theme(legend.justification=c(0,1), legend.position=c(0.05,0.95)) + 
      # reversed to match the priotization above
      scale_fill_manual(values=rev(cbPalette)) +
      ylab("Number of occurrences (in millions)") +
      xlab("Date") +
      scale_y_continuous(label = mill_formatter) + 
      ggtitle("Complete species occurrence records accessible through GBIF over time") 
    #ggsave(filename=paste(targetDir, "occ_recordComplete.png", sep="/"), plot=p1, width=8, height=6 )
    savePng(p1, paste(targetDir, "occ_recordComplete.png", sep="/"))
  }
  
  # Observations
  data <- ddply(DF[DF$basisOfRecord=="Observation",], .(snapshot), summarize, complete=sum(complete), total=sum(total), .drop=FALSE)
  data$incomplete <- data$total - data$complete
  total <- ddply(DF[DF$basisOfRecord=="Observation",], .(snapshot), summarize, total=sum(total), .drop=FALSE)
  data <- data[c("snapshot", "complete", "incomplete")]
  data <- melt(data, id=c("snapshot"))
  colnames(data) <- c("snapshot", "status", "occurrenceCount")
  # rev() here priorities the first one highest
  data$status <- factor(data$status, rev(displayOrder))
  # don't plot if only a single point
  if (length(unique(total$snapshot)) > 1) {
    cbPalette <- c("#08306b", "#FFFFE0")  
    p1 <- 
      ggplot(data, aes(x=snapshot,y=occurrenceCount)) +
      scale_x_date() +
      # unknown bug: displayOrder works in RStudio here, but not on command line
      geom_area(aes(fill=status, group=status, order=factor(status,c("complete", "incomplete"))), position='stack', linetype=0, alpha = 0.7 ) +
      geom_line(data = total, aes(y=total), colour = "#08306b", size=1) +
      geom_point(data = total, aes(y=total), colour = "#08306b") + 
      theme(legend.justification=c(0,1), legend.position=c(0.05,0.95)) + 
      # reversed to match the priotization above
      scale_fill_manual(values=rev(cbPalette)) +
      ylab("Number of occurrences (in millions)") +
      xlab("Date") +
      scale_y_continuous(label = mill_formatter) + 
      ggtitle("Complete observation records accessible through GBIF over time")   
    #ggsave(filename=paste(targetDir, "occ_observationComplete.png", sep="/"), plot=p1, width=8, height=6 )    
    savePng(p1, paste(targetDir, "occ_observationComplete.png", sep="/"))
  }
  
  # Specimens
  data <- ddply(DF[DF$basisOfRecord=="Specimen",], .(snapshot), summarize, complete=sum(complete), total=sum(total), .drop=FALSE)
  data$incomplete <- data$total - data$complete
  total <- ddply(DF[DF$basisOfRecord=="Specimen",], .(snapshot), summarize, total=sum(total), .drop=FALSE)
  data <- data[c("snapshot", "complete", "incomplete")]
  data <- melt(data, id=c("snapshot"))
  colnames(data) <- c("snapshot", "status", "occurrenceCount")
  # rev() here priorities the first one highest
  data$status <- factor(data$status, rev(displayOrder))
  # don't plot if only a single point
  if (length(unique(total$snapshot)) > 1) {
    cbPalette <- c("#00441b", "#FFFFE0")  
    p1 <- 
      ggplot(data, aes(x=snapshot,y=occurrenceCount)) +
      scale_x_date() +
      # unknown bug: displayOrder works in RStudio here, but not on command line
      geom_area(aes(fill=status, group=status, order=factor(status,c("complete", "incomplete"))), position='stack', linetype=0, alpha = 0.7 ) +
      geom_line(data = total, aes(y=total), colour = "#00441b", size=1) +
      geom_point(data = total, aes(y=total), colour = "#00441b") + 
      theme(legend.justification=c(0,1), legend.position=c(0.05,0.95)) + 
      # reversed to match the priotization above
      scale_fill_manual(values=rev(cbPalette)) +
      ylab("Number of occurrences (in millions)") +
      xlab("Date") +
      scale_y_continuous(label = mill_formatter) + 
      ggtitle("Complete specimen records accessible through GBIF over time")   
    #ggsave(filename=paste(targetDir, "occ_specimenComplete.png", sep="/"), plot=p1, width=8, height=6 ) 
    savePng(p1, paste(targetDir, "occ_specimenComplete.png", sep="/"))
  }
}