library(reshape2)
library(plyr)
library(ggplot2)
source("R/graph/utils.R")
source("R/graph/plot_utils.R")

occ_complete_date <- function(DF, plotsDir, suffix, cbPalette, title) {
  data <- ddply(DF, .(snapshot,temporal), summarize, occurrenceCount=sum(occurrenceCount), .drop=FALSE)
  displayOrder = c("YearMonthDay", "YearMonth", "YearOnly", "Unknown")
  # rev() here priorities the first one highest
  data$temporal <- factor(data$temporal, rev(displayOrder))
  total <- ddply(DF, .(snapshot), summarize, occurrenceCount=sum(occurrenceCount), .drop=FALSE)
  # don't plot if only a single point
  if (length(unique(total$snapshot)) > 1 && sum(total$occurrenceCount) > 0) {
    generatePlots(
      df=data,
      totalDf=total,
      plotsDir=plotsDir,
      targetFilePattern=paste("occ_complete_date", suffix, sep=""),
      plotTitle=title,
      dataCol="temporal",
      xCol="snapshot",
      yCol="occurrenceCount",
      xTitle="Date",
      yTitle="Number of occurrences (in millions)",
      yFormatter=mill_formatter,
      legendTitle="Precision",
      seriesColours=cbPalette,
      seriesValues=rev(displayOrder),
      seriesTitles=c("YearMonthDay"="Year, month and day", "YearMonth"="Year and month", "YearOnly"="Year only", "Unknown"="Unknown")
    )
  }
}

occ_complete_geo <- function(DF, plotsDir, suffix, cbPalette, title) {
  data <- ddply(DF, .(snapshot,geospatial), summarize, occurrenceCount=sum(occurrenceCount), .drop=FALSE)
  cbPalette <- cbPalette[-3]; # remove third color, since we have 1 less item
  displayOrder = c("Georeferenced", "CountryOnly", "Unknown")
  # rev() here priorities the first one highest
  data$geospatial <- factor(data$geospatial, rev(displayOrder))
  total <- ddply(DF, .(snapshot), summarize, occurrenceCount=sum(occurrenceCount), .drop=FALSE)
  # don't plot if only a single point
  if (length(unique(total$snapshot)) > 1 && sum(total$occurrenceCount) > 0) {
    generatePlots(
      df=data,
      totalDf=total,
      plotsDir=plotsDir,
      targetFilePattern=paste("occ_complete_geo", suffix, sep=""),
      plotTitle=title,
      dataCol="geospatial",
      xCol="snapshot",
      yCol="occurrenceCount",
      xTitle="Date",
      yTitle="Number of occurrences (in millions)",
      yFormatter=mill_formatter,
      legendTitle="Precision",
      seriesColours=cbPalette,
      seriesValues=rev(displayOrder),
      seriesTitles=c("Georeferenced"="Georeferenced", "CountryOnly"="Country only", "Unknown"="Unknown")
    )
  }
}

occ_complete_taxa <- function(DF, plotsDir, suffix, cbPalette, title) {
  data <- ddply(DF, .(snapshot,rank), summarize, occurrenceCount=sum(occurrenceCount), .drop=FALSE)
  displayOrder = c("Infraspecies", "Species", "Genus", "Higher taxon")
  # rev() here priorities the first one highest
  data$rank <- factor(data$rank, rev(displayOrder))
  total <- ddply(DF, .(snapshot), summarize, occurrenceCount=sum(occurrenceCount), .drop=FALSE)

  # on feedback, we want species to be the same as the total color, so we make infraspecies black
  tmpPalette <- c('#000000', cbPalette[1], cbPalette[2], cbPalette[4])

  # don't plot if only a single point
  if (length(unique(total$snapshot)) > 1 && sum(total$occurrenceCount) > 0) {
    generatePlots(
      df=data,
      totalDf=total,
      plotsDir=plotsDir,
      targetFilePattern=paste("occ_complete_kingdom", suffix, sep=""),
      plotTitle=title,
      dataCol="rank",
      xCol="snapshot",
      yCol="occurrenceCount",
      xTitle="Date",
      yTitle="Number of occurrences (in millions)",
      yFormatter=mill_formatter,
      legendTitle="Precision",
      seriesColours=tmpPalette,
      seriesValues=rev(displayOrder)
    )
  }
}

occ_complete_all <- function(DF, plotsDir, suffix, cbPalette, title) {
  total <- ddply(DF, .(snapshot), summarize, occurrenceCount=sum(occurrenceCount), .drop=FALSE)
  # don't plot if only a single point
  if (length(unique(total$snapshot)) > 1 && sum(total$occurrenceCount) > 0) {
    # filter them to complete only
    data <- DF[DF$rank %in% c("Infraspecies", "Species"),]
    data <- data[data$basisOfRecord %in% c("Specimen", "Observation", "Other"),]
    data <- data[data$temporal == "YearMonthDay",]
    data <- data[data$geospatial == "Georeferenced",]
    data <- ddply(data, .(snapshot), summarize, occurrenceCount=sum(occurrenceCount))

    # if there are complete records
    if(length(data$occurrenceCount) > 0) {
      data <- merge(x = data, y = total, by = "snapshot", all = TRUE)
      # if any values are NA we want 0 instead
      data[is.na(data)] <- 0
      colnames(data) <- c("snapshot", "complete", "incomplete")

      # incomplete is actually the total.  Subtract complete from total to make it correct
      data$incomplete <- data$incomplete - data$complete;
      data <- melt(data, id=c("snapshot"))
      colnames(data) <- c("snapshot", "status", "occurrenceCount")

    } else {
      # all records are incomplete!
      data <- total
      colnames(data) <- c("snapshot", "incomplete")
      data <- melt(data, id=c("snapshot"))
      colnames(data) <- c("snapshot", "status", "occurrenceCount")
    }

    displayOrder = c("complete", "incomplete")
    # rev() here priorities the first one highest
    data$status <- factor(data$status, rev(displayOrder))

    # customize the palette
    tmpPalette <- c(cbPalette[1],cbPalette[4])

    generatePlots(
      df=data,
      totalDf=total,
      plotsDir=plotsDir,
      targetFilePattern=paste("occ_complete", suffix, sep=""),
      plotTitle=title,
      dataCol="status",
      xCol="snapshot",
      yCol="occurrenceCount",
      xTitle="Date",
      yTitle="Number of occurrences (in millions)",
      yFormatter=mill_formatter,
      legendTitle="Status",
      seriesColours=tmpPalette,
      seriesValues=rev(displayOrder),
      seriesTitles=c("complete"="Complete", "incomplete"="Incomplete")
    )
  }
}

occ_complete <- function(sourceFile, plotsDir) {
  print(paste("Processing completeness graphs for: ", sourceFile))

  DF <- read.table(sourceFile, header=T, sep=",")
  DF$snapshot <- as.Date(DF$snapshot)
  DF$basisOfRecord <- sapply(DF$basisOfRecord, interpBasisOfRecord)
  DF$rank = sapply(DF$rank, interpRank)
  DF <- populate_factors(DF, c("basisOfRecord", "rank", "georeferenced", "temporal"))

  # all data
  data <- DF
  palette <- c("#5e3c99", "#b2abd2", "#fdb863", "#FFFFE0")
  occ_complete_date(data, plotsDir, "", palette, "Precision of record date")
  occ_complete_geo(data, plotsDir, "", palette, "Availability of coordinates and country")
  occ_complete_taxa(data, plotsDir, "", palette, "Precision of scientific identification")
  occ_complete_all(data, plotsDir, "", palette, "Complete species occurrence records accessible through GBIF over time")

  # observations
  data <- DF[DF$basisOfRecord == "Observation",]
  palette <- c("#053061", "#4393c3", "#d1e5f0", "#FFFFE0")
  occ_complete_date(data, plotsDir, "_observation", palette, "Precision of date of observation")
  occ_complete_geo(data, plotsDir, "_observation", palette, "Availability of coordinates and country for observations")
  occ_complete_taxa(data, plotsDir, "_observation", palette, "Precision of scientific identification for observations")
  occ_complete_all(data, plotsDir, "_observation", palette, "Complete observation records accessible through GBIF over time")

  # specimens
  data <- DF[DF$basisOfRecord == "Specimen",]
  #palette <- c("#00441b", "#5aae61", "#a6dba0", "#FFFFE0")
  palette <- c("#7f0000", "#d7301f", "#fc8d59", "#FFFFE0")
  occ_complete_date(data, plotsDir, "_specimen", palette, "Precision of specimen collection date")
  occ_complete_geo(data, plotsDir, "_specimen", palette, "Availability of coordinates and country for specimens")
  occ_complete_taxa(data, plotsDir, "_specimen", palette, "Precision of scientific identification for specimens")
  occ_complete_all(data, plotsDir, "_specimen", palette, "Complete specimen records accessible through GBIF over time")
}
