library(reshape2)
library(plyr)
library(ggplot2)
library(grid)
library(extrafont)
source("R/graph/utils.R")
source("R/graph/plot_utils.R")

#############
# Create the plot for number of species with occurrence records, by kingdom.
#
# sourceFile - csv containing the data
# plotsDir - the directory above the directories that will contain the images, relative to R working directory (e.g. report/country/DE/about)
# targetFilePattern - the first part of the file name omitting extension (e.g. "spe_kingdom" and not "spe_kingdom.png")
# palette - colour palette to match the number of series in the data
# title - overall chart title
#############
spe_kingdom <- function(sourceFile, plotsDir, targetFilePattern, palette, title) {
  print(paste("Processing species richness by kingdom graphs for: ", sourceFile))

  DF <- read.table(sourceFile, header=T, sep=",")
  DF$snapshot <- as.Date(DF$snapshot)
  DF$kingdom <- sapply(DF$kingdom, interpKingdom)
  DF <- populate_factors(DF, c("kingdom"))
  
  # group by kingdom, totaling the counts
  kingdom <- ddply(DF, .(snapshot,kingdom), summarize, speciesCount=sum(speciesCount), .drop=FALSE)
  total <- ddply(DF, .(snapshot), summarize, speciesCount=sum(speciesCount), .drop=FALSE)
  displayOrder = c("Animalia", "Plantae", "Other", "Unknown")

  # rev() here prioritizes the first one highest
  kingdom$kingdom <- factor(kingdom$kingdom, rev(displayOrder))
  
  # don't plot if only a single point
  if (length(unique(kingdom$snapshot)) > 1 && sum(kingdom$speciesCount) > 0) {
    generatePlots(
      df=kingdom, 
      totalDf=total, 
      plotsDir=plotsDir,
      targetFilePattern=targetFilePattern,
      plotTitle=title, 
      dataCol="kingdom", 
      xCol="snapshot", 
      yCol="speciesCount", 
      xTitle="Date", 
      yTitle="Number of species (in thousands)", 
      yFormatter=kilo_formatter, 
      legendTitle="Kingdom", 
      seriesColours=palette, 
      seriesValues=rev(displayOrder)
    )
  }
}



