# Table 1 - web traffic: top 5 cities by session for each country
library(RGoogleAnalytics)
library(dplyr)
source("R/html-json/utils.R")

generateTrafficTop5Cities <- function(start_date, end_date) {
  # real secrets, not for commit!
  load("R/country-reports/token_file")
  ValidateToken(token)
  
  query.list <- Init(start.date = start_date,
                     end.date = end_date,                   
                     dimensions = "ga:countryIsoCode, ga:city",
                     metrics = "ga:sessions",                   
                     max.results = 10000,
                     sort = "ga:countryIsoCode, -ga:sessions",
                     table.id = "ga:73962076")
  
  ga.query <- QueryBuilder(query.list)
  ga.data <- GetReportData(ga.query, token, paginate_query = T)
  colnames(ga.data) <- c("CountryCode", "city", "sessions")
  #Pagination required
  
  # group_by() and top_n() are dplyr functions that simulate SQL.
  top5 <- group_by(ga.data, CountryCode)  
  # this awkward construction because of strange behaviour on command line where CountryCode column wasn't appearing after summarise (but worked in RStudio)
  total_traffic <- data.frame(CountryCode=unique(top5$CountryCode), total=summarise(top5, total=sum(as.integer(sessions))), stringsAsFactors = FALSE)
  # we pull 6 in case one of them has "(not set)" as a top 6 country, in which case we drop it and have at most 5 real cities
  top5 <- top_n(top5, 6)
  top5 <- top5[which(top5$city != "(not set)"),]
  top5 <- merge(top5, total_traffic)
  top5$percentage <- paste(as.character(format(round((top5$sessions/top5$total)*100, digits=2), nsmall = 2)), "%", sep="")
  
  top5$ranking <- ave(top5$sessions, top5$CountryCode, FUN=function(x) order(-x) )
  top5$sessions <- prettyNum(top5$sessions, big.mark=",")
    
  # finally, drop Totals column since all we need is percent, and reorder columns so rank is first
  top5 <- top5[, !names(top5) %in% c("total")]
  top5 <- top5[c(1,5,2,3,4)]
    
  # now transform into one row per country
  flat_top5 <- NULL
  for (i in 1:5) {
    singleRank <- top5[top5$ranking == i,]
    
    # rename columns
    header <- c("CountryCode", 
                paste(paste("city", i, sep=""), "_rank", sep=""),
                paste(paste("city", i, sep=""), "_name", sep=""),
                paste(paste("city", i, sep=""), "_sessions", sep=""),
                paste(paste("city", i, sep=""), "_sessions_percent", sep=""))
    colnames(singleRank) <- header
    
    if (is.null(flat_top5)) {
      flat_top5 <- singleRank      
    } else {
      flat_top5 <- merge(flat_top5, singleRank, by.x="CountryCode", by.y="CountryCode", all = TRUE)
      #break
    }
  } 
  # all NA to empty string
  flat_top5[is.na(flat_top5)] <- ""

  return(flat_top5)
}