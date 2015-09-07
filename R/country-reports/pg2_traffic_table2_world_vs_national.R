# Table 2 - web traffic: worldwide and national analytics breakdown
require(RGoogleAnalytics)
source("R/html-json/utils.R")

# needed for web traffic page:

# csv columns
# country_sessions, country_percent_of_global_sessions, city1_name, city1_sessions, city1_percent_of_country_sessions, <for 5 cities>, 
# global_sessions, global_pages_per_session, global_avg_session_duration, global_bounce_rate, global_perecent_new_sessions, 
# country_pages_per_session, country_avg_session_duration, country_bounce_rate, country_perecent_new_sessions

# chart: Figure 3 "Number of user sessions per week originating in country"

# TODO: parameterize start and end dates
generateTrafficStats <- function() {
  # TODO: real secrets, not for commit!
  load("R/country-reports/token_file")
  ValidateToken(token)
  
  # fetch the worldwide traffic stats from Google Analytics
  rawQuery <- Init(start.date = "2014-07-01",
                     end.date = "2015-06-30",                   
                     metrics = "ga:sessions, ga:pageviewsPerSession, ga:avgSessionDuration, ga:bounceRate, ga:percentNewSessions",                   
                     max.results = 10000,
                     table.id = "ga:73962076")
  query <- QueryBuilder(rawQuery)
  worldwideTraffic <- GetReportData(query, token)
  # Converts char columns to numeric and enforced two digit format
  # TODO: this throws a warning but works in the end. Strange transposition attempt...
  worldwideTraffic[,2:5] <- data.frame(sapply(worldwideTraffic[,2:5], FUN=function(x) format(round(as.numeric(x), digits = 2), nsmall = 2)), stringsAsFactors = F)
  colnames(worldwideTraffic)=c("global_sessions", "global_pages_per_sessions", "global_avg_sessions_duration", "global_bounce_rate", "global_percent_new_sessions")
  
  # fetch the per country traffic stats from Google Analytics
  rawQuery <- Init(start.date = "2014-07-01",
                end.date = "2015-06-30",                   
                dimensions = "ga:countryIsoCode",
                metrics = "ga:sessions, ga:pageviewsPerSession, ga:avgSessionDuration, ga:bounceRate, ga:percentNewSessions",                   
                max.results = 10000,
                table.id = "ga:73962076")
  query <- QueryBuilder(rawQuery)
  perCountryTraffic <- GetReportData(query, token)
  # Converts char columns to numeric and enforced two digit format
  perCountryTraffic[,3:6] <- data.frame(sapply(perCountryTraffic[,3:6], FUN=function(x) format(round(as.numeric(x), digits = 2), nsmall = 2)), stringsAsFactors = F)
  colnames(perCountryTraffic)=c("CountryCode", "country_sessions", "country_pages_per_sessions", "country_avg_sessions_duration", "country_bounce_rate", "country_percent_new_sessions")
  
  mergedTraffic <- cbind(perCountryTraffic, worldwideTraffic)
  # TODO: give everyone a minimum of 0.01%, since nobody wants to see 0
  mergedTraffic$country_percent_of_global_sessions <- paste(format(round(100*mergedTraffic$country_sessions / mergedTraffic$global_sessions, digits=2), nsmall = 2), "%", sep="")
  # pretty print total sessions
  mergedTraffic$country_sessions <- prettyNum(mergedTraffic$country_sessions, big.mark=",")
  mergedTraffic$global_sessions <- prettyNum(mergedTraffic$global_sessions, big.mark=",")
  
  return(mergedTraffic)
}