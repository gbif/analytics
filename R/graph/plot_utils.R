library(reshape2)
library(plyr)
library(ggplot2)
library(grid)
library(extrafont)
source("R/graph/utils.R")

webDirSuffix <- "figure"
printDirSuffix <- "print"

webTheme <- theme(
  text=element_text(family="Arial Narrow", size=14),
  legend.justification=c(0,1), 
  legend.position=c(0.05,0.95),
  legend.background=element_rect(size=2, color='white'),
  legend.spacing=unit(-1,"lines"),
  panel.background=element_rect(fill = "#e8e8e8"),
  panel.spacing=unit(c(0,0,0,0), "lines"),
  plot.title=element_text(size=14, face="bold", vjust=1.5),
  axis.title.x=element_text(vjust=0.2),
  axis.title.y=element_text(vjust=1.1),
  plot.margin = unit(c(0.1, 0.35, 0.1, 0.1), "cm") # added plot margin to see 2018
  )

printTheme <- theme(
  legend.justification=c(0,1), 
  legend.position=c(0.10,0.85),
  legend.background=element_rect(size=10, color='white'),
  legend.spacing=unit(-1,"lines"),
  text=element_text(family="Arial Narrow", size=20),
  panel.background=element_rect(fill = "#e8e8e8"),
  panel.spacing=unit(c(0,0,0,0), "lines"),
  plot.title=element_text(size=24, face="bold", vjust=1.5),
  axis.title.x=element_text(vjust=0.2),
  axis.title.y=element_text(vjust=1.1),
  plot.margin = unit(c(0.1, 0.45, 0.1, 0.1), "cm") # added plot margin to see 2018
)

#############
# Create a plot and tweak to match print and web settings, then save as pdf/png if desired.
#
# doWeb - boolean whether to save a web version of plot (default: TRUE)
# doPrint - boolean whether to save a print version of plot (default: TRUE)
# df - dataframe containing the data to be plotted
# totalDf - dataframe containing totals of all series in the df (to plot the top summary line)
# plotsDir - the directory above the directories that will contain the images, relative to R working direcotry (e.g. report/country/DE/about)
# targetFilePattern - filename to write, but without extension (i.e. expect something like "spe_kingdom" and not "spe_kingdom.pdf")
# plotTitle - title at top of plot
# dataCol - name of column in df holding the different series names ("factors") (e.g. "kingdom"). Values probably match seriesTitles 
# xCol - name of column in df holding x axis values (e.g. "snapshot")
# yCol - name of column in df and totalDf holding y axis values (e.g. "speciesCount")
# xTitle - title shown for x axis
# yTitle - title shown for y axis
# yFormatter - function that transforms values from yCol into readable values (e.g. kilo_converter, mill_converter)
# legendTitle - title of the legend
# seriesColours - colour swatches to show in the legend (must match order of seriesValues)
# seriesValues - the distinct values in the plotted column (factor values) 
# seriesTitles - default is null, but supply a named vector matching seriesValues to override the legend entries (e.g. seriesValues is c("constant1","constant2") and seriesTitles could be c("constant1"="Nice Name","constant2"="Pretty Name")
#############
generatePlots <- function(doWeb=TRUE, doPrint=FALSE, df, totalDf, plotsDir, targetFilePattern, plotTitle, dataCol, xCol, yCol, xTitle, yTitle, yFormatter, legendTitle, seriesColours, seriesValues, seriesTitles=NULL) {
  if (doWeb) {
    webPlot <- createPlot(webTheme, df, totalDf, plotTitle, dataCol, xCol, yCol, xTitle, yTitle, yFormatter, legendTitle, seriesColours, seriesValues, seriesTitles)
    webDir <- paste(plotsDir, webDirSuffix, sep="/")
    dir.create(webDir, showWarnings=F)  

    #png
    webFile <- paste(webDir, paste(targetFilePattern, ".png", sep=""), sep="/")
    savePng(file=webFile, plot=webPlot)

    #svg
    svgFile <- paste(webDir, paste(targetFilePattern, ".svg", sep=""), sep="/")
    saveSvg(file=svgFile, plot=webPlot)
  }
  if (doPrint) {
    #pdf
    printPlot <- createPlot(printTheme, df, totalDf, plotTitle, dataCol, xCol, yCol, xTitle, yTitle, yFormatter, legendTitle, seriesColours, seriesValues, seriesTitles)
    printDir <- paste(plotsDir, printDirSuffix, sep="/")
    dir.create(printDir, showWarnings=F)  
    printFile <- paste(printDir, paste(targetFilePattern, ".pdf", sep=""), sep="/")
    print(paste("Writing print plot: ", printFile))
    ggsave(filename=printFile, plot=printPlot, width=21, height=11, scale=0.75)
    embed_fonts(file=printFile)
  }
}

###########
# Creates the ggplot. This assumes the x-axis will be Date (years) in roughly the range 2008-2015.
# Note the reverses in seriesColours, seriesValues, seriesTitles - RStudio will look wrong but commandline will look right...
###########
createPlot <- function(plotTheme, df, totalDf, plotTitle, dataCol, xCol, yCol, xTitle, yTitle, yFormatter, legendTitle, seriesColours, seriesValues, seriesTitles) {
  minXAxis <- as.Date(min(df[[xCol]]))-20
  maxXAxis <- as.Date(max(df[[xCol]]))+20 # increased margins to fit 2018
  maxYAxis <- 1.04*max(totalDf[[yCol]])
  
  seriesColours <- rev(seriesColours)
  seriesValues <- rev(seriesValues)

  legend <- scale_fill_manual(values=seriesColours, name=legendTitle)
  if (!is.null(seriesTitles)) {
    legend <- scale_fill_manual(values=seriesColours, name=legendTitle, labels=seriesTitles)
  }
  
  
  plot <- 
    ggplot(df, aes_string(x=xCol, y=yCol)) +
    scale_x_date(expand=c(0,0),limits=c(minXAxis,maxXAxis)) +
    geom_area(aes_q(fill=as.name(dataCol), group=as.name(dataCol)), position='stack', linetype=0, alpha=0.8) +
    geom_line(data=totalDf, colour="black", size=1) +
    geom_point(data=totalDf, colour="black") +
    plotTheme + 
    legend +
    ylab(yTitle) +
    xlab(xTitle) +
    scale_y_continuous(expand=c(0,0),limits=c(0,maxYAxis),label=yFormatter) +
    ggtitle(plotTitle) 

  return(plot)
}

###########
# This function is just for the weekly web traffic chart on page 2. Lives here because of same need for print and web themes and dirs. For now print only (produces pdf).
# TODO: fix hardcoded dates/labels
###########
generateWeeklyTrafficPlot <- function(df, plotsDir, targetFilePattern) {
  #pdf
  printPlot <- createWeeklyTrafficPlot(df)
  dir.create(plotsDir, showWarnings=F)  
  printFile <- paste(plotsDir, paste(targetFilePattern, ".pdf", sep=""), sep="/")
  print(paste("Writing print plot: ", printFile))
  ggsave(filename=printFile, plot=printPlot, width=4, height=1, scale=2)
  embed_fonts(file=printFile)
}

createWeeklyTrafficPlot <- function(df) {
  plot <- 
    ggplot(df, aes(x = `yearWeek`, y = sessions, group = CountryCode)) + 
    geom_area(position = "identity", colour="black", fill="blue", alpha=0.2) + 
    geom_line(size = 1.5, colour="blue", alpha=0.6) + 
    geom_point(size = 4, colour="blue", alpha=0.6) +
    scale_x_discrete(breaks = c("201440", "201503", "201516"), labels=c("September 2014", "January 2015", "April 2015")) +
    theme(axis.title.x = element_blank(), axis.title.y = element_blank()) 
}

###########
# This function is just for the monthly download chart on page 3. Lives here because of same need for print and web themes and dirs. For now print only (produces pdf).
# TODO: fix hardcoded dates/labels
###########
generateMonthlyDownloadPlot <- function(df, plotsDir, targetFilePattern) {
  #pdf
  printPlot <- createMonthlyDownloadPlot(df)
  dir.create(plotsDir, showWarnings=F)  
  printFile <- paste(plotsDir, paste(targetFilePattern, ".pdf", sep=""), sep="/")
  print(paste("Writing print plot: ", printFile))
  ggsave(filename=printFile, plot=printPlot, width=4, height=2, scale=2)
  embed_fonts(file=printFile)
}

createMonthlyDownloadPlot <- function(df) {
  minY <- min(df$count)
  maxYAxis <- max(df$count)*1.04
  
  plot <- 
    ggplot(df, aes(x = `year_month`, y = count, group = CountryCode)) + 
    geom_area(position = "identity", colour="black", fill="blue", alpha=0.6) + 
    geom_line(size = 1.5, colour="blue", alpha=0.6) +
    theme(
      axis.text.x=element_text(angle = 45, hjust = 1),
      axis.title.y=element_text(vjust=1.1)
    ) +
    scale_x_discrete(name="",expand=c(0,0))
  
  if (minY > 1000000) {
    plot <- plot +
      scale_y_continuous(name="Records downloaded (in millions)",expand=c(0,0),limits=c(0,maxYAxis),label=mill_formatter)
  } else {
    plot <- plot +
    scale_y_continuous(name="Records downloaded (in thousands)",expand=c(0,0),limits=c(0,maxYAxis),label=kilo_formatter)
  }
}