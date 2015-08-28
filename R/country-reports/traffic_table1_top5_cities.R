# Table 1 - web traffic: top 5 cities by session for each country
require(RGoogleAnalytics)
require(dplyr)
source("R/html-json/utils.R")

# TODO: parameterize start and end dates
generateTrafficTop5Cities <- function() {
  # TODO: real secrets, not for commit!
  load("R/country-reports/token_file")
  ValidateToken(token)
  
  query.list <- Init(start.date = "2014-07-01",
                     end.date = "2015-06-30",                   
                     dimensions = "ga:countryIsoCode, ga:city",
                     metrics = "ga:sessions",                   
                     max.results = 10000,
                     sort = "ga:countryIsoCode, -ga:sessions",
                     table.id = "ga:73962076")
  
  ga.query <- QueryBuilder(query.list)
  ga.data <- GetReportData(ga.query, token, paginate_query = T)
  #Pagination required
  
  # group_by() and top_n() are dplyr functions that simulate SQL.
  top5 <- group_by(ga.data, countryIsoCode)
  total_traffic <- summarise(top5, total=sum(as.integer(sessions)))
  # Creates data frame for total sessions by country. Works because of the group_by()
  top5 <- top_n(top5, 5)
  top5 <- left_join(top5, total_traffic, by='countryIsoCode')
  top5$percentage <- paste(format(round((top5$sessions/top5$total)*100, digits=2), nsmall = 2), "%", sep="")
  top5$ranking <- ave(top5$sessions, top5$countryIsoCode, FUN=function(x) order(-x) )
  top5[is.na(top5)] <- "No Data"
  top5$city[top5$city == "(not set)"] <- "Unknown"
  # finally, drop Totals column since all we need is percent, and reorder columns so rank is first
  top5 <- top5[-4]
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
      flat_top5 <- merge(flat_top5, singleRank, all = TRUE)
    }
  } 
  # all NA to empty string
  flat_top5[is.na(flat_top5)] <- ""

  return(flat_top5)
}