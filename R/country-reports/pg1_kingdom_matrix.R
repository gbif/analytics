library(dplyr)

generateKingdomMatrix <- function(csvDataFile) {
  kingdomRawDF <- read.csv(csvDataFile, na.strings="")

  kingdomDF <- kingdomRawDF
  colnames(kingdomDF) <- c("CountryCode", "kingdom", "count", "percent_change")
  # drop global values (which have no countrycode)
  kingdomDF <- kingdomDF[!is.na(kingdomDF$CountryCode), ]
  
  kingdoms <- as.character(unique(kingdomDF[,2]))
  countryCodes <- as.character(unique(kingdomDF[,1]))
  
  flat_kingdoms<-data.frame(countryCodes)
  colnames(flat_kingdoms) <- c("CountryCode")
  
  countCols <- c()
  percentCols <- c()
  flat_kingdoms <- NULL
  
  for (kingdom in kingdoms) {
    singleKingdom <- data.frame(kingdomDF[kingdomDF$kingdom == kingdom,], stringsAsFactors = FALSE)
    # drop kingdom column (all identical)
    singleKingdom <- singleKingdom[-2]
    # add commas for thousands in the count column
    singleKingdom[2] <- lapply(singleKingdom[2], function(x) prettyNum(x, big.mark=",", preserve.width = "none"))

    # rename columns
    header <- c("CountryCode", 
                countCol(kingdom),
                percentCol(kingdom)
                )
    colnames(singleKingdom) <- header
    # percent col gets '-' for NA, and otherwise a +/- prepended and '%' appended
    singleKingdom[,3] <- as.numeric(as.character(singleKingdom[,3]))
    singleKingdom[,3] <- ifelse(singleKingdom[,3] == 0, "0 %", ifelse(singleKingdom[,3] > 0, paste("+ ", paste(as.character(singleKingdom[,3]), "%", sep=""), sep=""), paste("- ", paste(as.character(singleKingdom[,3]), "%", sep=""), sep="")))

    if (is.null(flat_kingdoms)) {
      flat_kingdoms <- data.frame(singleKingdom, stringsAsFactors=FALSE)
    } else {
      flat_kingdoms <- merge(flat_kingdoms, singleKingdom, all = TRUE)
    }
    
    countCols <- c(countCols, countCol(kingdom))
    percentCols <- c(percentCols, percentCol(kingdom))
  } 
  # all count NA to 0 (NAs due to left join absence), and add , for 1000s
  flat_kingdoms[countCols][is.na(flat_kingdoms[countCols])] <- 0
  # all % NA to '-'
  flat_kingdoms[percentCols][is.na(flat_kingdoms[percentCols])] <- "-"
  
  return(flat_kingdoms)
}

countCol <- function(kingdom) {
  return(paste(tolower(kingdom), "_count", sep=""))
}

percentCol <- function(kingdom) {
  return(paste(tolower(kingdom), "_percent_change", sep=""))
}