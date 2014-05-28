library(reshape2)
library(plyr)
library(ggplot2) 
source("R/graph/utils.R")

occ_complete_date <- function(DF, targetDir, suffix, cbPalette, title) {
  filename <- paste("occ_complete_date", suffix, ".png", sep="")
  data <- ddply(DF, .(snapshot,temporal), summarize, occurrenceCount=sum(occurrenceCount))
  displayOrder = c("YearMonthDay", "YearMonth", "YearOnly", "Unknown")
  # rev() here priorities the first one highest
  data$temporal <- factor(data$temporal, rev(displayOrder))
  total <- ddply(DF, .(snapshot), summarize, occurrenceCount=sum(occurrenceCount))
  if(length(total$snapshot) > 0) {
    p1 <- 
      ggplot(data, aes(x=snapshot,y=occurrenceCount)) +
      scale_x_date() +
      # unknown bug: displayOrder works in RStudio here, but not on command line
      geom_area(aes(fill=temporal, group = temporal, order = factor(temporal,c("YearMonthDay", "YearMonth", "YearOnly", "Unknown"))), position='stack', linetype=0, alpha=0.7 ) +
      geom_line(data = total, colour = "black", size=1) +
      geom_point(data = total, colour = "black") +
      theme(legend.justification=c(0,1), legend.position=c(0.05,0.95)) + 
      # reversed to match the priotization above
      scale_fill_manual(values=rev(cbPalette), name = "Precision", labels=rev(c("Year, month and day", "Year and month", "Year only", "Unknown"))) +
      ylab("Number of occurrences (in millions)") +
      xlab("Date") +
      scale_y_continuous(label = mill_formatter) + 
      ggtitle(title) 
    #ggsave(filename=paste(targetDir, filename, sep="/"), plot=p1, width=8, height=6 )
    savePng(p1, paste(targetDir, filename, sep="/"))
  }
}

occ_complete_geo <- function(DF, targetDir, suffix, cbPalette, title) {
  filename <- paste("occ_complete_geo", suffix, ".png", sep="")
  data <- ddply(DF, .(snapshot,geospatial), summarize, occurrenceCount=sum(occurrenceCount))
  cbPalette <- cbPalette[-3]; # remove third color, since we have 1 less item
  displayOrder = c("Georeferenced", "CountryOnly", "Unknown")
  # rev() here priorities the first one highest
  data$geospatial <- factor(data$geospatial, rev(displayOrder))
  total <- ddply(DF, .(snapshot), summarize, occurrenceCount=sum(occurrenceCount))
  if(length(total$snapshot) > 0) {
    p1 <- 
      ggplot(data, aes(x=snapshot,y=occurrenceCount)) +
      scale_x_date() +
      # unknown bug: displayOrder works in RStudio here, but not on command line
      geom_area(aes(fill=geospatial, group = geospatial, order = factor(geospatial,c("Georeferenced", "CountryOnly", "Unknown"))), position='stack', linetype=0, alpha=0.7 ) +
      geom_line(data = total, colour = "black", size=1) +
      geom_point(data = total, colour = "black") +
      theme(legend.justification=c(0,1), legend.position=c(0.05,0.95)) + 
      # reversed to match the priotization above
      scale_fill_manual(values=rev(cbPalette), name = "Precision", labels=rev(c("Georeferenced", "Country only", "Unknown"))) +
      ylab("Number of occurrences (in millions)") +
      xlab("Date") +
      scale_y_continuous(label = mill_formatter) + 
      ggtitle(title) 
    #ggsave(filename=paste(targetDir, filename, sep="/"), plot=p1, width=8, height=6 )
    savePng(p1, paste(targetDir, filename, sep="/"))
  }
}

occ_complete_taxa <- function(DF, targetDir, suffix, cbPalette, title) {
  filename <- paste("occ_complete_kingdom", suffix, ".png", sep="")
  data <- ddply(DF, .(snapshot,rank), summarize, occurrenceCount=sum(occurrenceCount))
  displayOrder = c("Infraspecies", "Species", "Genus", "Higher taxon")
  # rev() here priorities the first one highest
  data$rank <- factor(data$rank, rev(displayOrder))
  total <- ddply(DF, .(snapshot), summarize, occurrenceCount=sum(occurrenceCount))
  
  # on feedback, we want species to be the same as the total color, so we make infraspecies black
  tmpPalette <- c('#000000', cbPalette[1], cbPalette[2], cbPalette[4])
  
  if(length(total$snapshot) > 0) {
    p1 <- 
      ggplot(data, aes(x=snapshot,y=occurrenceCount)) +
      scale_x_date() +
      # unknown bug: displayOrder works in RStudio here, but not on command line
      geom_area(aes(fill=rank, group = rank, order = factor(rank,c("Infraspecies", "Species", "Genus", "Higher taxon"))), position='stack', linetype=0, alpha=0.7 ) +
      geom_line(data = total, colour = "black", size=1) +
      geom_point(data = total, colour = "black") +
      theme(legend.justification=c(0,1), legend.position=c(0.05,0.95)) + 
      # reversed to match the priotization above
      scale_fill_manual(values=rev(tmpPalette), name = "Precision", labels=rev(c("Infraspecies", "Species", "Genus", "Higher taxon"))) +
      ylab("Number of occurrences (in millions)") +
      xlab("Date") +
      scale_y_continuous(label = mill_formatter) + 
      ggtitle(title) 
    #ggsave(filename=paste(targetDir, filename, sep="/"), plot=p1, width=8, height=6 )
    savePng(p1, paste(targetDir, filename, sep="/"))
  }
}

occ_complete_all <- function(DF, targetDir, suffix, cbPalette, title) {
  filename <- paste("occ_complete", suffix, ".png", sep="")
  total <- ddply(DF, .(snapshot), summarize, occurrenceCount=sum(occurrenceCount))
  if(length(total$snapshot) > 0) {
    
    # filter them to complte only
    data <- DF[DF$rank %in% c("Infraspecies", "Species"),]
    data <- data[data$basisOfRecord %in% c("Specimen", "Observation", "Other"),]
    data <- data[data$temporal == "YearMonthDay",]
    data <- data[data$geospatial == "Georeferenced",]
    data <- ddply(data, .(snapshot), summarize, occurrenceCount=sum(occurrenceCount))
    
    # if there are complete records
    if(length(data$occurrenceCount) > 0) {
      data <- merge(x = data, y = total, by = "snapshot", all = TRUE)
      colnames(data) <- c("snapshot", "complete", "incomplete")
      
      # incomplete is actually the total.  Subtract complete from total to make it correct
      data$incomplete <- data$incomplete - data$complete;
      data <- melt(data, id=c("snapshot"))
      colnames(data) <- c("snapshot", "status", "count")        
      
    } else {
      # all records are incomplete!
      data <- total
      colnames(data) <- c("snapshot", "incomplete")
      data <- melt(data, id=c("snapshot"))
      colnames(data) <- c("snapshot", "status", "count")        
    }    
      

    displayOrder = c("complete", "incomplete")
    # rev() here priorities the first one highest
    data$status <- factor(data$status, rev(displayOrder))    
      
    # customize the palette
    tmpPalette <- c(cbPalette[1],cbPalette[4])
  
    p1 <- 
      ggplot(data, aes(x=snapshot)) +
        scale_x_date() +
        geom_area(aes(y=count, fill=status, group = status, order = factor(status,c("complete","incomplete"))), position='stack', linetype=0, alpha=0.7 ) +
        geom_line(data = total, aes(y=occurrenceCount), colour = "black", size=1) +
        geom_point(data = total, aes(y=occurrenceCount), colour = "black") +
        theme(legend.justification=c(0,1), legend.position=c(0.05,0.95)) + 
        ylab("Number of occurrences (in millions)") +
        xlab("Date") +
        scale_y_continuous(label = mill_formatter) + 
        scale_fill_manual(values=rev(tmpPalette), labels=c("Incomplete", "Complete"), name = "Status") +      
        ggtitle(title) 
      #ggsave(filename=paste(targetDir, filename, sep="/"), plot=p1, width=8, height=6 )
      savePng(p1, paste(targetDir, filename, sep="/"))
  }
}

occ_complete <- function(sourceFile, targetDir) {
  #sourceFile <- "/Users/tim/git/stats/report/global/csv/occ_complete.csv";
  
  print(paste("Processing completeness  graphs for: ", sourceFile))
  dir.create(targetDir, showWarnings=F)  
  
  DF <- read.table(sourceFile, header=T, sep=",")
  DF$snapshot <- as.Date(DF$snapshot)
  DF$basisOfRecord <- sapply(DF$basisOfRecord, interpBasisOfRecord)
  DF$rank = sapply(DF$rank, interpRank)
  
  # all data
  data <- DF
  palette <- c("#5e3c99", "#b2abd2", "#fdb863", "#FFFFE0")
  occ_complete_date(data, targetDir, "", palette, "Precision of record date")
  occ_complete_geo(data, targetDir, "", palette, "Availability of coordinates and country")
  occ_complete_taxa(data, targetDir, "", palette, "Precision of scientific identification")
  occ_complete_all(data, targetDir, "", palette, "Complete species occurrence records accessible through GBIF over time")
  
  # observations
  data <- DF[DF$basisOfRecord == "Observation",]
  palette <- c("#053061", "#4393c3", "#d1e5f0", "#FFFFE0")
  occ_complete_date(data, targetDir, "_observation", palette, "Precision of date of observation")
  occ_complete_geo(data, targetDir, "_observation", palette, "Availability of coordinates and country for observations")
  occ_complete_taxa(data, targetDir, "_observation", palette, "Precision of scientific identification for observations")
  occ_complete_all(data, targetDir, "_observation", palette, "Complete observation records accessible through GBIF over time")
  
  # specimens
  data <- DF[DF$basisOfRecord == "Specimen",]
  #palette <- c("#00441b", "#5aae61", "#a6dba0", "#FFFFE0")
  palette <- c("#7f0000", "#d7301f", "#fc8d59", "#FFFFE0")
  occ_complete_date(data, targetDir, "_specimen", palette, "Precision of specimen collection date")
  occ_complete_geo(data, targetDir, "_specimen", palette, "Availability of coordinates and country for specimens")
  occ_complete_taxa(data, targetDir, "_specimen", palette, "Precision of scientific identification for specimens")
  occ_complete_all(data, targetDir, "_specimen", palette, "Complete specimen records accessible through GBIF over time")
}
