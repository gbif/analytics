# Page 6, 4 newest publishers from country
library(jsonlite)
library(dplyr)
source("R/html-json/utils.R")

generateNewestPublishers <- function(apiUrl,cutoff_date) {
  orgPath <- "organization?country="

  ISO_3166_1 <- gbif_iso_countries()

  maxOrgs = 4 #Max number of organizations/publishers returned

  # Uses the JSONLite to retrieve new publishers by country
  newest_publishers <- data.frame(country=character(), title=character(), rank=integer(), stringsAsFactors = FALSE)
  for (country in ISO_3166_1$Alpha_2) {
    new_orgs <- fromJSON(paste(apiUrl, paste(orgPath, country, sep=""), sep=""))
    res <- new_orgs$results

    if (new_orgs$count != 0){
      res <- res[order(res$created, decreasing = T),][as.Date(res$created) < cutoff_date, ]
      for (j in 1:maxOrgs){
        if (!is.null(res$title[j])) {
          newest_publishers[nrow(newest_publishers)+1, ] <- c(country, res$title[j], j)
        }
      }
    }
  }
  # drop NA rows
  newest_publishers <- subset(newest_publishers, !is.na(newest_publishers[ , 2]))

  # now transform into one row per country
  flat_pubs <- NULL
  for (i in 1:maxOrgs) {
    singleRank <- newest_publishers[newest_publishers$rank == i,]
    # drop unneeded rank column
    singleRank <- singleRank[,-3]
    # rename columns
    header <- c("CountryCode",
                paste(paste("newest_publisher_", i, sep=""), "_name", sep=""))
    colnames(singleRank) <- header
    singleRank$CountryCode <- as.character(singleRank$CountryCode)

    if (is.null(flat_pubs)) {
      flat_pubs <- singleRank
    } else {
      flat_pubs <- merge(flat_pubs, singleRank, by="CountryCode", all = TRUE)
    }
  }
  # all NA to empty string
  flat_pubs[is.na(flat_pubs)] <- ""

  return(flat_pubs)
}
