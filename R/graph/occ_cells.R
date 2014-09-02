library(reshape2)
library(plyr)
library(ggplot2) 
source("R/graph/utils.R")

occ_cells <- function(sourceFile, targetDir, title, targetFile, palette) {
  print(paste("Processing cell graphs for: ", sourceFile))
  dir.create(targetDir, showWarnings=F)  
  
  DF <- read.table(sourceFile, header=T, sep=",")
  DF$snapshot <- as.Date(DF$snapshot)  
  total <- ddply(DF, .(snapshot), summarize, speciesCount=sum(one_cell,under_twenty_cells,under_hundred_cells,under_thousand_cells,over_thousand_cells), .drop=FALSE)
  DF <- melt(DF, id=c("snapshot"))
  colnames(DF) <- c("snapshot", "cellCount", "speciesCount")
  displayOrder <- c("one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells")
  DF$cellCount <- factor(DF$cellCount, levels=displayOrder)
  
  # don't plot if only a single point
  if (length(unique(DF$snapshot)) > 1) {
    p1 <- ggplot(DF, aes(x=snapshot,y=speciesCount)) + 
             scale_x_date() +
             geom_area(aes(fill=cellCount, group = cellCount, order=factor(cellCount, levels=rev(c("one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells")))), position='stack', linetype=0, alpha=0.7 ) +
             ylab("Number of species (in thousands)") +
             xlab("Date") +
             geom_line(data = total, colour = "black", size=1) +
             geom_point(data = total, colour = "black") +    
             scale_y_continuous(label = kilo_formatter) +
             scale_fill_manual(values=rev(palette),
                               labels=c("One cell", "2-20 cells", "20-100 cells", "100-1000 cells", "1000+ cells"),
                               name = "Cell count") +
             ggtitle(title) 
    
    savePng(p1, paste(targetDir, targetFile, sep="/"))
  }
}
