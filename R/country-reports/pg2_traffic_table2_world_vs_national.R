# Table 2 - web traffic: worldwide and national analytics breakdown
library(RGoogleAnalytics)
source("R/html-json/utils.R")

generateTrafficStats <- function(start_date, end_date) {
  # real secrets, not for commit!
  load("R/country-reports/token_file")
  ValidateToken(token)
  
  # fetch the worldwide traffic stats from Google Analytics
  rawQuery <- Init(start.date = start_date,
                     end.date = end_date,                   
                     metrics = "ga:sessions, ga:pageviewsPerSession, ga:avgSessionDuration, ga:bounceRate, ga:percentNewSessions",                   
                     max.results = 10000,
                     table.id = "ga:73962076")
  query <- QueryBuilder(rawQuery)
  worldwideTraffic <- GetReportData(query, token)
  # Enforced two digit format
  worldwideTraffic[,2:5] <- sapply(worldwideTraffic[,2:5], FUN=function(x) round(as.numeric(x), digits = 2))
  colnames(worldwideTraffic)=c("global_sessions", "global_pages_per_sessions", "global_avg_sessions_duration", "global_bounce_rate", "global_percent_new_sessions")
  worldwideTraffic$global_avg_sessions_duration <- formatSeconds(worldwideTraffic$global_avg_sessions_duration)
  
  # fetch the per country traffic stats from Google Analytics
  rawQuery <- Init(start.date = start_date,
                end.date = end_date,                   
                dimensions = "ga:countryIsoCode",
                metrics = "ga:sessions, ga:pageviewsPerSession, ga:avgSessionDuration, ga:bounceRate, ga:percentNewSessions",                   
                max.results = 10000,
                table.id = "ga:73962076")
  query <- QueryBuilder(rawQuery)
  perCountryTraffic <- GetReportData(query, token)
  # Converts char columns to numeric and enforced two digit format
  perCountryTraffic[,3:6] <- data.frame(sapply(perCountryTraffic[,3:6], FUN=function(x) format(round(as.numeric(x), digits = 2), nsmall = 2)), stringsAsFactors = F)
  colnames(perCountryTraffic)=c("CountryCode", "country_sessions", "country_pages_per_sessions", "country_avg_sessions_duration", "country_bounce_rate", "country_percent_new_sessions")
  perCountryTraffic$country_avg_sessions_duration <- formatSeconds(as.numeric(perCountryTraffic$country_avg_sessions_duration))
  
  mergedTraffic <- cbind(perCountryTraffic, worldwideTraffic)
  # TODO: give everyone with > 0 traffic a minimum of 0.01%, since nobody wants to see 0
  mergedTraffic$country_percent_of_global_sessions <- paste(format(round(100*mergedTraffic$country_sessions / mergedTraffic$global_sessions, digits=2), nsmall = 2), "%", sep="")
  # pretty print total sessions
  mergedTraffic$country_sessions <- prettyNum(mergedTraffic$country_sessions, big.mark=",")
  mergedTraffic$global_sessions <- prettyNum(mergedTraffic$global_sessions, big.mark=",")
  
  return(mergedTraffic)
}

formatSeconds <- function(seconds) {
  min <- as.integer(seconds %/% 60)
  sec <- as.integer(seconds %% 60)
  result <- paste(sprintf("%.1d", min), paste(":", sprintf("%.2d", sec), sep=""), sep="")

  return(result)
}