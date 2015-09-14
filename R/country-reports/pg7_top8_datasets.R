# page 7, top 8 datasets contributing about country
library(dplyr)
library(jsonlite)

# ask the given apiUrl (e.g. "http://api.gbif.org/v1/") for the names of top 8 datasets about country
generatePg7Top8Datasets <- function(apiUrl) {
  top8 <- read.csv("hadoop/cr_pg7_top8_datasets.csv", na.strings="", encoding="UTF-8", header = FALSE)
  colnames(top8) <- c("CountryCode", "dataset_key", "count", "rank")
  top8$count <- prettyNum(top8$count, big.mark = ",", preserve.width = "individual")
  top8$title <- sapply(top8$dataset_key, getDatasetName)
  top8$modified <- sapply(top8$dataset_key, getDatasetModified)
  # now drop the key column
  top8 <- top8[,-2]
  
  flat_top8 <- NULL
  for (i in 1:8) {
    singleRank <- top8[top8$rank == i,]
    # rename columns
    header <- c("CountryCode", 
                paste(paste("pg7dataset", i, sep=""), "_count", sep=""),
                paste(paste("pg7dataset", i, sep=""), "_rank", sep=""),
                paste(paste("pg7dataset", i, sep=""), "_title", sep=""),
                paste(paste("pg7dataset", i, sep=""), "_modified", sep=""))
    colnames(singleRank) <- header
    if (is.null(flat_top8)) {
      flat_top8 <- singleRank
    } else {
      flat_top8 <- merge(flat_top8, singleRank, all = TRUE)
    }
  } 
  # remove no country row
  flat_top8 <- flat_top8[!is.na(flat_top8$CountryCode), ]
  # all NA to empty string
  flat_top8[is.na(flat_top8)] <- ""
  
  return(flat_top8)
}

# TODO: this is criminal - combine into one api call and extract the two fields in one shot
getDatasetName <- function(datasetKey) {
  datasetPath <- paste(apiUrl, paste("dataset/", datasetKey, sep=""), sep="")
  dataset = tryCatch({
    fromJSON(datasetPath)
  }, warning = function(w) {
    NULL
  }, error = function(e) {
    NULL
  }, finally = {
    NULL
  })

  result <- ""
  if (!is.null(dataset)) {
    result <- dataset$title
  }
  
  return(result)
}

getDatasetModified <- function(datasetKey) {
  datasetPath <- paste(apiUrl, paste("dataset/", datasetKey, sep=""), sep="")
  dataset = tryCatch({
    fromJSON(datasetPath)
  }, warning = function(w) {
    NULL
  }, error = function(e) {
    NULL
  }, finally = {
    NULL
  })
  
  result <- ""
  if (!is.null(dataset)) {
    result <- strsplit(dataset$modified, split="T", fixed=TRUE)[[1]][1]
  }
  
  return(result)
}