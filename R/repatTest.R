#install.packages("circlize")
library(circlize)

source("R/csv/Utils.R")

prepareGlobalCSV(
  sourceFile = "repat_about4.csv", 
  sourceSchema = c("country", "publisher", "count"),
  targetFile = "repat_about.csv"
)

sourceFile <- "./report/global/csv/repat_about.csv"
DF <- read.table(sourceFile, header=T, sep=",")

circos.clear()

# see: http://www.statmethods.net/advgraphs/parameters.html
par(mar = c(1, 1, 1, 1), lwd = 0.5, cex = 0.5)

factors = unique(DF$country)
circos.par("default.track.height" = 0.3, "cell.padding" = c(0, 0, 0, 0))
circos.initialize(factors = factors, xlim=c(0,1))

circos.trackPlotRegion(factors = factors, ylim = c(0, 1), bg.col = "grey", bg.border = NA, track.height = 0.05)

circos.link("NA", 5, "GB", 5, col = "red", border = "blue", top.ratio = 0.2) 


#circos.link(x["country"], 5, x["publisher"], 5, col = "red", border = "blue", top.ratio = 0.2) )
for(k in 1:nrow(DF)){
  c <- DF[k,"country"];
  p <- DF[k,"publisher"];
  if (c %in% factors && p %in% factors && !is.na(c)) {
    print(paste(c,p, "plotting"))
    circos.link(c, 0, p, 0, col = "red") 
  } else {
    print(paste(c,p, "SKIPPING"))
  }
}





#apply(DF[,c('country','publisher')], 1, function(x) print(paste(x["publisher"], "->", x['country'])))

apply(DF[,c('country','publisher')], 1, function(x)  circos.link(x["country"], 5, x["publisher"], 5, col = "red", border = "blue", top.ratio = 0.2) )
#circos.link(DF$country, 5, DF$publisher, 5)


  circos.clear()