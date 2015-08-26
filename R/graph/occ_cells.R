library(reshape2)
library(plyr)
library(ggplot2) 
source("R/graph/utils.R")
source("R/graph/plot_utils.R")

occ_cells <- function(sourceFile, plotsDir, targetFilePattern, title, palette) {
  print(paste("Processing cell graphs for: ", sourceFile))

  DF <- read.table(sourceFile, header=T, sep=",")
  DF$snapshot <- as.Date(DF$snapshot)  
  total <- ddply(DF, .(snapshot), summarize, speciesCount=sum(one_cell,under_twenty_cells,under_hundred_cells,under_thousand_cells,over_thousand_cells), .drop=FALSE)
  DF <- melt(DF, id=c("snapshot"))
  colnames(DF) <- c("snapshot", "cellCount", "speciesCount")
  displayOrder <- c("one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells")
  DF$cellCount <- factor(DF$cellCount, levels=displayOrder)
  
  # don't plot if only a single point
  if (length(unique(DF$snapshot)) > 1) {
    generatePlots(
      df=DF,
      totalDf=total, 
      plotsDir=plotsDir,
      targetFilePattern=targetFilePattern,
      plotTitle=title, 
      dataCol="cellCount", 
      xCol="snapshot", 
      yCol="speciesCount", 
      xTitle="Date",
      yTitle="Cell count", 
      yFormatter=kilo_formatter, 
      legendTitle="Cell count", 
      seriesColours=palette, 
      seriesValues=displayOrder,
      seriesTitles=c("one_cell"="One cell", "under_twenty_cells"="2-20 cells", "under_hundred_cells"="20-100 cells", "under_thousand_cells"="100-1000 cells", "over_thousand_cells"="1000+ cells")
    )
  }
}
