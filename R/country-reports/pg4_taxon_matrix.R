# Page 4 taxon matrix (class and phylum bubbles). Uses the results of hive queries in pg4_taxon_matrix.q
library(dplyr)

# for testing
# csvClassDataFile <- "hadoop/cr_pg4_class_matrix.csv"
# csvPhylumDataFile <- "hadoop/cr_pg4_phylum_matrix.csv"

generateClassPhylumMatrix <- function(csvClassDataFile, csvPhylumDataFile) {
  
  # class portion
  classDF <- read.csv(csvClassDataFile, na.strings="")
  colnames(classDF) <- c("CountryCode", "taxon", "count", "percent_increase")
  flat_classes <- flatten(classDF)
  
  # phylum portion
  phylumDF <- read.csv(csvPhylumDataFile, na.strings="")
  colnames(phylumDF) <- c("CountryCode", "taxon", "count", "percent_increase")
  flat_phyla <- flatten(phylumDF)
  
  # merge the flattened dfs
  final_flat <- merge(flat_classes, flat_phyla, by="CountryCode")
  
  return(final_flat)
}

# expects 4 column df as CountryCode, taxon, count, percent_increase and will flatten to one row per country, with 2 columns for each taxon
flatten <- function(df) {
  # drop global values (which have no countrycode)
  df <- df[!is.na(df$CountryCode), ]
  
  taxa <- as.character(unique(df$taxon))
  countryCodes <- as.character(unique(df$CountryCode))
  
  flat_taxa<-data.frame(countryCodes)
  colnames(flat_taxa) <- c("CountryCode")
  
  countCols <- c()
  percentCols <- c()
  for (taxon in taxa) {
    singleTaxon <- data.frame(df[df$taxon == taxon,], stringsAsFactors = FALSE)
    # drop taxon column (all identical)
    singleTaxon <- singleTaxon[-2]
    # add commas for thousands in the count column
    singleTaxon[2] <- lapply(singleTaxon[2], function(x) prettyNum(x, big.mark=",", preserve.width = "none"))
    
    # rename columns
    header <- c("CountryCode", 
                countCol(taxon),
                percentCol(taxon)
    )
    colnames(singleTaxon) <- header
    # percent col gets '-' for NA, and otherwise a +/- prepended and '%' appended
    singleTaxon[,3] <- as.numeric(as.character(singleTaxon[,3]))
    singleTaxon[,3] <- ifelse(singleTaxon[,3] > 0, paste("+ ", paste(as.character(singleTaxon[,3]), "%", sep=""), sep=""), paste("- ", paste(as.character(singleTaxon[,3]), "%", sep=""), sep="")) 
    
    if (is.null(flat_taxa)) {
      flat_taxa <- data.frame(singleTaxon, stringsAsFactors=FALSE)
    } else {
      flat_taxa <- merge(flat_taxa, singleTaxon, all = TRUE)
    }
    
    countCols <- c(countCols, countCol(taxon))
    percentCols <- c(percentCols, percentCol(taxon))
  } 
  # all count NA to 0 (NAs due to left join absence), and add , for 1000s
  flat_taxa[countCols][is.na(flat_taxa[countCols])] <- 0
  # all % NA to '-'
  flat_taxa[percentCols][is.na(flat_taxa[percentCols])] <- "-"
  
  return(flat_taxa)
}

countCol <- function(taxon) {
  return(paste(tolower(taxon), "_count", sep=""))
}

percentCol <- function(taxon) {
  return(paste(tolower(taxon), "_percent_change", sep=""))
}