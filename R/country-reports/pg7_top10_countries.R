# Page 7, Table 3 - top 10 countries contributing data about country
library(dplyr)
source("R/html-json/utils.R")

generatePg7Top10Countries <- function() {
  top10 <- read.csv("hadoop/cr_pg7_top10_countries.csv", na.strings="", encoding="UTF-8", header = FALSE, stringsAsFactors = FALSE)
  colnames(top10) <- c("CountryCode", "contrib_country", "count", "rank")
  top10 <- top10[!is.na(top10$CountryCode), ]
  top10[is.na(top10)] <- ""
  top10$count <- prettyNum(top10$count, big.mark = ",", preserve.width = "individual")
  ISO_3166_1 <- gbif_iso_countries()
  simpleCountries <- data.frame(ISO_3166_1$Alpha_2,ISO_3166_1$Name)
  colnames(simpleCountries) <- c("country_code", "contrib_country_name")
  top10 <- merge(top10, simpleCountries, by.x="contrib_country", by.y="country_code")
  # drop contrib_country col in favour of full name
  top10 <- top10[,-1]
  
  flat_top10 <- NULL
  for (i in 1:10) {
    singleRank <- top10[top10$rank == i,]
    # rename columns
    header <- c("CountryCode", 
                paste(paste("pg7country", i, sep=""), "_count", sep=""),
                paste(paste("pg7country", i, sep=""), "_rank", sep=""),
                paste(paste("pg7country", i, sep=""), "_contrib_country", sep=""))
    colnames(singleRank) <- header
    if (is.null(flat_top10)) {
      flat_top10 <- singleRank
    } else {
      flat_top10 <- merge(flat_top10, singleRank, all = TRUE)
    }
  } 

  return(flat_top10)
}