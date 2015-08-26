library(reshape2)
library(plyr)
library(ggplot2) 
source("R/graph/utils.R")
source("R/graph/plot_utils.R")

occ_kingdomBasisOfRecord <- function(plotsDir, sourceFile) {
  print(paste("Processing kingdomBasisOfRecord graphs for: ", sourceFile))

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

  # don't plot if only a single point
  if (length(unique(DF$snapshot)) > 1 && sum(kingdom$occurrenceCount) > 0) {
    cbPalette <- c("#005397", "#b2df8a", "#984ea3", "#FFFFE0")
    generatePlots(
      df=kingdom,
      totalDf=total, 
      plotsDir=plotsDir,
      targetFilePattern="occ_kingdom", 
      plotTitle="Species occurrence records accessible through GBIF over time", 
      dataCol="kingdom", 
      xCol="snapshot", 
      yCol="occurrenceCount", 
      xTitle="Date",
      yTitle="Number of occurrences (in millions)", 
      yFormatter=mill_formatter, 
      legendTitle="Kingdom", 
      seriesColours=cbPalette, 
      seriesValues=rev(displayOrder)
    )
  }

  displayOrder <- c("Observation", "Specimen", "Other", "Unknown")
  data <- ddply(DF[DF$kingdom=="Animalia",], .(snapshot,basisOfRecord), summarize, occurrenceCount=sum(occurrenceCount), .drop=FALSE)
  # rev() here priorities the first one highest
  data$basisOfRecord <- factor(data$basisOfRecord, rev(displayOrder))
  total <- ddply(data, .(snapshot), summarize, occurrenceCount=sum(occurrenceCount), .drop=FALSE)
  # don't plot if only a single point
  if (length(unique(total$snapshot)) > 1 && sum(total$occurrenceCount) > 0) {
    cbPalette <- c("#005397", "#357FB3", "#62B0D3", "#FFFFE0")
    generatePlots(
      df=data,
      totalDf=total, 
      plotsDir=plotsDir,
      targetFilePattern="occ_animaliaBoR", 
      plotTitle="Animalia records as observed in GBIF index over time", 
      dataCol="basisOfRecord", 
      xCol="snapshot", 
      yCol="occurrenceCount", 
      xTitle="Date",
      yTitle="Number of occurrences (in millions)", 
      yFormatter=mill_formatter, 
      legendTitle="Basis of Record", 
      seriesColours=cbPalette, 
      seriesValues=rev(displayOrder)
    )
  }
  
  data <- ddply(DF[DF$kingdom=="Plantae",], .(snapshot,basisOfRecord), summarize, occurrenceCount=sum(occurrenceCount), .drop=FALSE)
  # rev() here priorities the first one highest
  data$basisOfRecord <- factor(data$basisOfRecord, rev(displayOrder))
  total <- ddply(data, .(snapshot), summarize, occurrenceCount=sum(occurrenceCount), .drop=FALSE)
  # don't plot if only a single point
  if (length(unique(total$snapshot)) > 1 && sum(total$occurrenceCount) > 0) {
    cbPalette <- c("#006B32", "#00894D", "#2AAD7C", "#FFFFE0")
    generatePlots(
      df=data,
      totalDf=total, 
      plotsDir=plotsDir,
      targetFilePattern="occ_plantaeBoR", 
      plotTitle="Plantae records as observed in GBIF index over time", 
      dataCol="basisOfRecord", 
      xCol="snapshot", 
      yCol="occurrenceCount", 
      xTitle="Date",
      yTitle="Number of occurrences (in millions)", 
      yFormatter=mill_formatter, 
      legendTitle="Basis of Record", 
      seriesColours=cbPalette, 
      seriesValues=rev(displayOrder)
    )
  }    
}