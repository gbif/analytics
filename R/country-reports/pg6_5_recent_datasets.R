# page 6 - 5 most recently published datasets
library(RPostgreSQL)
library(dplyr)
library(jsonlite)
# NOTE: you need to create a db_secrets.R that contains the following variables:
# 
# Postgres prod registry
# ps_host
# ps_databaseName 
# ps_user 
# ps_password 
source("R/country-reports/db_secrets.R")

# ask the given apiUrl (e.g. "http://api.gbif.org/v1/") for the dataset count for each of the 5 most recent, per country
generateRecentDatasets <- function(apiUrl) {

  # TODO: this modified date is last time the registry entry was updated - we should probably show "last modified" for most recently modified record from this dataset
  ps_sql <- "SELECT * FROM (
    SELECT o.country, d.key as key, d.title AS dataset_title, 
    CASE 
    WHEN d.type = 'METADATA' THEN 'Metadata dataset'
    WHEN d.type = 'CHECKLIST' THEN 'Checklist dataset'
    WHEN d.type = 'OCCURRENCE' THEN 'Occurrence dataset' 
    END AS type,
    to_char(d.modified, 'DD Mon, YYYY') AS date, o.title AS organization_title, row_number() OVER (PARTITION BY o.country ORDER BY date(d.modified) DESC) AS rank FROM organization o
    JOIN dataset d ON o.key = d.publishing_organization_key
    WHERE d.deleted IS NULL AND date(d.modified) < '2015-07-01'
  ) t1 WHERE rank <=5"
  ps_con <- dbConnect(RPostgreSQL::PostgreSQL(), user=ps_user, password=ps_password, dbname=ps_databaseName, host=ps_host)
  datasetsDF <- dbGetQuery(ps_con, ps_sql)
  dbDisconnect(ps_con)

  datasetsDF$count <- mapply(getCount, datasetsDF$type, datasetsDF$key)
  datasetsDF$count <- prettyNum(datasetsDF$count, big.mark=",", preserve.width = "individual")
  datasetsDF$count <- paste(as.character(datasetsDF$count), " records.", sep="")
  
  # add styling for report use
  datasetsDF$dataset_title <- paste(datasetsDF$dataset_title, ".", sep="")
  datasetsDF$type <- paste(datasetsDF$type, ".", sep="")
  datasetsDF$date <- paste("Updated ", paste(datasetsDF$date, ".", sep=""), sep="")
  datasetsDF$organization_title <- paste("Published by ", paste(datasetsDF$organization_title, ".", sep=""), sep="")
  
  # now transform into one row per country
  flat_top5 <- NULL
  for (i in 1:5) {
    singleRank <- datasetsDF[datasetsDF$rank == i,]
    # rename columns
    header <- c("CountryCode", 
                paste(paste("dataset", i, sep=""), "_key", sep=""),
                paste(paste("dataset", i, sep=""), "_title", sep=""),
                paste(paste("dataset", i, sep=""), "_type", sep=""),
                paste(paste("dataset", i, sep=""), "_date", sep=""),
                paste(paste("dataset", i, sep=""), "_org", sep=""),
                paste(paste("dataset", i, sep=""), "_rank", sep=""),
                paste(paste("dataset", i, sep=""), "_count", sep=""))
    colnames(singleRank) <- header
    if (is.null(flat_top5)) {
      flat_top5 <- singleRank
    } else {
      flat_top5 <- merge(flat_top5, singleRank, all = TRUE)
    }
  } 
  # remove no country row
  flat_top5 <- flat_top5[!is.na(flat_top5$CountryCode), ]
  # all NA to empty string
  flat_top5[is.na(flat_top5)] <- ""
  
  return(flat_top5)
}

# Call the gbif api to get the count for a dataset, given its type.
# if occurrence
# http://api.gbif.org/v1/occurrence/count?datasetKey=f6e0064a-7862-4d74-909a-61e229bcc49b (single number)
# if checklist
# http://api.gbif.org/v1/dataset/f6e0064a-7862-4d74-909a-61e229bcc49b/metrics (field: usagesCount)
# if metadata, always 0
getCount <- function(datasetType, datasetKey) {
  occurrencePath <- "occurrence/count?datasetKey="
  checklistPathPre <- "dataset"
  checklistPathPost <- "metrics"
  
  if (datasetType == "Metadata dataset") {
    return(0)
  }
  
  if (datasetType == "Checklist dataset") {
    clPath <- paste(apiUrl, paste(checklistPathPre, paste(datasetKey, checklistPathPost, sep="/"), sep="/"), sep="")
    clCount = tryCatch({
      clMetrics <- fromJSON(clPath)
      clMetrics$usagesCount
    }, warning = function(w) {
      0
    }, error = function(e) {
      0
    }, finally = {
      0
    })
    return(clCount)
  }
  
  # leaves occurrence
  occPath <- paste(apiUrl, paste(occurrencePath, datasetKey, sep=""), sep="")
  occCount = tryCatch({
    fromJSON(occPath)
  }, warning = function(w) {
    0
  }, error = function(e) {
    0
  }, finally = {
    0
  })
  return(occCount)
}