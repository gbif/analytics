library(reshape2)
library(plyr)
library(ggplot2) 
source("R/graph/utils.R")

occ_kingdomBasisOfRecord <- function(sourceFile, targetDir) {
  print(paste("Processing kingdomBasisOfRecord graphs for: ", sourceFile))
  dir.create(targetDir, showWarnings=F)  
  
  DF <- read.table(sourceFile, header=T, sep=",")
  DF$snapshot <- as.Date(DF$snapshot)
  DF$kingdom <- sapply(DF$kingdom, interpKingdom)
  DF$basisOfRecord <- sapply(DF$basisOfRecord, interpBasisOfRecord)
  DF <- populate_factors(DF, c("kingdom", "basisOfRecord"))

  # group by kingdom, totaling the counts
  kingdom <- ddply(DF, .(snapshot,kingdom), summarize, occurrenceCount=sum(occurrenceCount), .drop=FALSE)
  
  total <- ddply(DF, .(snapshot), summarize, occurrenceCount=sum(occurrenceCount), .drop=FALSE)
  displayOrder = c("Animalia", "Plantae", "Other", "Unknown")

  # rev() here priorities the first one highest
  kingdom$kingdom <- factor(kingdom$kingdom, rev(displayOrder))

  #cbPalette <- c("#357FB3", "#006B32", "#AE140E", "#FFFFE0")
  #cbPalette <- c("#e31a1c", #005397", "#ff7f00", "#00441b", "#FFFFE0")
  cbPalette <- c("#005397", "#b2df8a", "#984ea3", "#FFFFE0") 
  
  # don't plot if only a single point
  if (length(unique(DF$snapshot)) > 1 && sum(kingdom$occurrenceCount) > 0) {
    p1 <- 
      ggplot(kingdom, aes(x=snapshot,y=occurrenceCount)) +
      scale_x_date() +
      # unknown bug: displayOrder works in RStudio here, but not on command line
      geom_area(aes(fill=kingdom, group = kingdom, order = factor(kingdom,c("Animalia", "Plantae", "Other", "Unknown"))), position='stack', linetype=0, alpha = 0.7 ) +
      #geom_area(aes(fill=kingdom, group = kingdom, position='stack', linetype=0, alpha = 0.7 ) +
      geom_line(data = total, colour = "black", size=1) +
      geom_point(data = total, colour = "black") +
      theme(legend.justification=c(0,1), legend.position=c(0.05,0.95)) + 
      # reversed to match the priotization above
      scale_fill_manual(values=rev(cbPalette)) +
      ylab("Number of occurrences (in millions)") +
      xlab("Date") +
      scale_y_continuous(label = mill_formatter) + 
      ggtitle("Species occurrence records accessible through GBIF over time") 
    #ggsave(filename=paste(targetDir, "occ_kingdom.png", sep="/"), plot=p1, width=8, height=6 )
    savePng(p1, paste(targetDir, "occ_kingdom.png", sep="/"))
  }

  displayOrder <- c("Observation", "Specimen", "Other", "Unknown")
  data <- ddply(DF[DF$kingdom=="Animalia",], .(snapshot,basisOfRecord), summarize, occurrenceCount=sum(occurrenceCount), .drop=FALSE)
  # rev() here priorities the first one highest
  data$basisOfRecord <- factor(data$basisOfRecord, rev(displayOrder))
  total <- ddply(data, .(snapshot), summarize, occurrenceCount=sum(occurrenceCount), .drop=FALSE)
  # don't plot if only a single point
  if (length(unique(total$snapshot)) > 1 && sum(total$occurrenceCount) > 0) {
    cbPalette <- c("#005397", "#357FB3", "#62B0D3", "#FFFFE0")
    
    p1 <- 
      ggplot(data, aes(x=snapshot,y=occurrenceCount)) +
      scale_x_date() +
      geom_area(aes(fill=basisOfRecord, group=basisOfRecord, order = factor(basisOfRecord,c("Observation", "Specimen", "Other", "Unknown"))), position='stack', linetype=0, alpha = 0.7) +
      geom_line(data = total, colour = "black", size=1) +
      geom_point(data = total, colour = "black") +
      theme(legend.justification=c(0,1), legend.position=c(0.05,0.95)) + 
      # reversed to match the priotization above
      scale_fill_manual(values=rev(cbPalette), name = "Basis of record") +
      ylab("Number of occurrences (in millions)") +
      xlab("Date") +
      scale_y_continuous(label = mill_formatter) + 
      ggtitle("Animalia records as observed in GBIF index over time")
    #ggsave(filename=paste(targetDir, "occ_animaliaBoR.png", sep="/"), plot=p1, width=8, height=6 )    
    savePng(p1, paste(targetDir, "occ_animaliaBoR.png", sep="/"))
  }
  
  data <- ddply(DF[DF$kingdom=="Plantae",], .(snapshot,basisOfRecord), summarize, occurrenceCount=sum(occurrenceCount), .drop=FALSE)
  # rev() here priorities the first one highest
  data$basisOfRecord <- factor(data$basisOfRecord, rev(displayOrder))
  total <- ddply(data, .(snapshot), summarize, occurrenceCount=sum(occurrenceCount), .drop=FALSE)
  # don't plot if only a single point
  if (length(unique(total$snapshot)) > 1 && sum(total$occurrenceCount) > 0) {
    cbPalette <- c("#006B32", "#00894D", "#2AAD7C", "#FFFFE0")
    p1 <- 
      ggplot(data, aes(x=snapshot,y=occurrenceCount)) +
      scale_x_date() +
      geom_area(aes(fill=basisOfRecord, group=basisOfRecord, order = factor(basisOfRecord,c("Observation", "Specimen", "Other", "Unknown"))), position='stack', linetype=0, alpha = 0.7) +
      geom_line(data = total, colour = "black", size=1) +
      geom_point(data = total, colour = "black") +
      theme(legend.justification=c(0,1), legend.position=c(0.05,0.95)) + 
      # reversed to match the priotization above
      scale_fill_manual(values=rev(cbPalette), name = "Basis of record") +
      ylab("Number of occurrences (in millions)") +
      xlab("Date") +
      scale_y_continuous(label = mill_formatter) + 
      ggtitle("Plantae records as observed in GBIF index over time")
    #ggsave(filename=paste(targetDir, "occ_plantaeBoR.png", sep="/"), plot=p1, width=8, height=6 )
    savePng(p1, paste(targetDir, "occ_plantaeBoR.png", sep="/"))
  }    
}