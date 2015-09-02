# page 1 chart and blob about published papers using GBIF data. Data fetched via GBIF mendeley API.
library(jsonlite)
source("R/html-json/utils.R")

# ask the given apiUrl (e.g. "http://api.gbif.org/v1/") for publications data
generatePublicationStats <- function(apiUrl) {
  # load country map into global var
  gbif_iso_countries()
  
  currentYear <- format(Sys.time(), "%Y")
  startYear <- 2008
  
  current <- c()
  allTime <- c()
  for (countryCode in ISO_3166_1$Alpha_2) {
    print(paste("Fetching mendeley stats for ", countryCode, sep=""))
    currentValue <- fromJSON(
      paste(paste(paste(paste(paste(apiUrl, "mendeley/country/", sep=""), countryCode, sep=""), "/json/range/", sep=""), currentYear, sep=""), currentYear, sep="/")
    )
    current <- c(current, ifelse(grepl("No document", currentValue), "0", currentValue))
    
    allTimeValue <- fromJSON(
      paste(paste(paste(paste(paste(apiUrl, "mendeley/country/", sep=""), countryCode, sep=""), "/json/range/", sep=""), startYear, sep=""), currentYear, sep="/")
    )
    allTime <- c(allTime, ifelse(grepl("No document", allTimeValue), "0", allTimeValue))
  }
  
  header <- c("CountryCode", "publications_current_period", "publications_all_time")
  pg1_blob <- data.frame(ISO_3166_1$Alpha_2, current, allTime)
  colnames(pg1_blob) <- header
  
  return(pg1_blob)
}

# Was meant to be the pg1 pub bar chart, but it's too ugly for use
# header <- c()
# counts <- c()
# for (year in 2008:2015) {
#   header <- c(header, year)
#   counts <- c(counts, fromJSON(paste(paste("http://api.gbif-uat.org/v1/mendeley/year/", year, sep=""), "/count", sep="")))
# }
# mendeley_all <- data.frame(header)
# mendeley_all[,2] <- counts
# colnames(mendeley_all) <- c("Year", "Publications")
# 
# plot <- 
#   ggplot(mendeley_all, aes(x=Year, y=Publications,fill=factor(Year))) +
#   geom_bar(stat="identity", width=1) + 
#   scale_fill_manual(values=c("red", "yellow", "blue", "green", "orange", "purple", "brown", "black")) +
#   coord_flip() +
#   theme(axis.title.x=element_blank(),
#         axis.title.y=element_blank(),
#         legend.position="none"
#         )
