# page 1 chart and blob about published papers using GBIF data. Data fetched via GBIF mendeley API.
library(jsonlite)
source("R/html-json/utils.R")

# ask the given apiUrl (e.g. "http://api.gbif.org/v1/") for publications data
generatePublicationStats <- function(apiUrl) {
  ISO_3166_1 <- gbif_iso_countries()
  
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
