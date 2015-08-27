# Table 1 - web traffic: top 5 cities by session for each country
require(RGoogleAnalytics)
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
  
  top5 <- group_by(ga.data, countryIsoCode)
  total_traffic <- summarise(top5, total=sum(as.integer(sessions)))
  #Creates data frame for total sessions by country. Works because of the group_by()
  top5 <- top_n(top5, 5)
  #group_by() and top_n() are dplyr functions that simulate SQL. Above could be written more concisely
  
  top5 <- left_join(top5, total_traffic, by='countryIsoCode')
  top5$percentage <- format(round((top5$sessions/top5$total)*100, digits=2), nsmall = 2)
  
  enforcer <- data.frame(iso=character(), table1.rank=integer(), stringsAsFactors = F)
  #Data frame init
  
  for(k in iso_country[,1]){    
      for(j in 1:5){
          enforcer[nrow(enforcer)+1,] <- c(k, j)        
      }
  }
  enforcer[,2] <- as.integer(enforcer[,2])
  #The enforcer is filled with rank values 1:5 and iso country code
  
  top5$ranking <- ave(top5$sessions, top5$countryIsoCode, FUN=function(x) order(-x) )
  #The ranking column is added and it is populated by number of sessions and grouped by isocode
  top5 <- data.frame(lapply(left_join(enforcer, top5, by=c('iso' = 'countryIsoCode','table1.rank' = 'ranking')), as.character), stringsAsFactors = F)
  #a left join data frame that avoids turning chars to factors
  top5[is.na(top5)] <- "no data"
  top5$city[top5$city == "(not set)"] <- "unknown"
  
  fct<-as.character(unique(top5[,2]))
  countries<-as.character(unique(top5[,1]))
  
  df_top5<-data.frame(countries)
  
  for (j in fct){
      #each element in fct gets a new dataframe that is then pasted onto df_top5
      newdf<-top5[top5$table1.rank==j, c('city','sessions','percentage')]
      for (k in colnames(newdf)){        
          df_top5[,paste(k,j, sep="")]<-newdf[,k]    
      }    
  }
  
  df_top5[] <- lapply(df_top5, as.character)

  return(df_top5)
}