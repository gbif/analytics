# Page 7, Table 3 - top 10 countries contributing data about country
require(dplyr)

generatePg7Top10Countries <- function() {
  top10 <- read.csv("hadoop/cr_pg7_top10_countries.csv", na.strings="", encoding="UTF-8", header = FALSE, stringsAsFactors = FALSE)
  colnames(top10) <- c("CountryCode", "contrib_country", "count", "rank")
  top10 <- top10[!is.na(top10$CountryCode), ]
  top10[is.na(top10)] <- ""
  top10$count <- prettyNum(top10$count, big.mark = ",", preserve.width = "individual")
  
  flat_top10 <- NULL
  for (i in 1:10) {
    singleRank <- top10[top10$rank == i,]
    # rename columns
    header <- c("CountryCode", 
                paste(paste("pg7country", i, sep=""), "_contrib_country", sep=""),
                paste(paste("pg7country", i, sep=""), "_count", sep=""),
                paste(paste("pg7country", i, sep=""), "_rank", sep=""))
    colnames(singleRank) <- header
    if (is.null(flat_top10)) {
      flat_top10 <- singleRank
    } else {
      flat_top10 <- merge(flat_top10, singleRank, all = TRUE)
    }
  } 

  return(flat_top10)
}