# page 3 most recent 5 articles published by authors from country (uses mendeley api)
library(jsonlite)
source("R/html-json/utils.R")

# apiUrl <- "http://api.gbif-uat.org/v1/"
# ask the given apiUrl (e.g. "http://api.gbif.org/v1/") for most recent publication for each country
generateRecentPublications <- function(apiUrl) {
  
  # load country map into global var
  gbif_iso_countries()
  
  recentArticles <- NULL
  for (countryCode in ISO_3166_1$Alpha_2) {
    print(paste("Fetching mendeley recent pubs for ", countryCode, sep=""))
    countryArticles <- fromJSON(
      paste(paste(paste(paste(paste(apiUrl, "mendeley/country/", sep=""), countryCode, sep=""), "/json/recent5", sep="")))
    )
    if (class(countryArticles) == "list" && grepl("No document", countryArticles)) {
      # fill empty row for country
    } else {
      countryCol <- c()
      rank <- c()
      for (row in 1:length(countryArticles$title)) {
        countryCol <- c(countryCol, countryCode)
        rank <- c(rank, row)
      }
      countryArticles[,"rank"] <- rank
      countryArticles[,"CountryCode"] <- countryCol

      # extract the inner authors construct (a list of two column data frames, first_name and last_name, each of which are lists) and construct an authors string
      # space rule: if <= 4 authors, list them all with last one getting & instead of , (e.g. Lennon, McCartney, Harrison & Starr)
      # if > 4 authors list first 3 with commas and et al (e.g. Jagger, Richards, Wyman et al)
      if ("authors" %in% colnames(countryArticles)) {
        nestedAuthors <- countryArticles$authors
        nameList <- c()
        for (i in 1:length(nestedAuthors)) {
          prettyAuthors <- ""
          authorCount <- length(nestedAuthors[[i]]$last_name)
          if (authorCount <= 4) {
            for (j in 1:authorCount) {
              prettyAuthors <- paste(prettyAuthors, nestedAuthors[[i]]$last_name[[j]], sep="")
              if (j == authorCount-1) {
                prettyAuthors <- paste(prettyAuthors, " & ", sep="")
              } else if (j != authorCount) {
                prettyAuthors <- paste(prettyAuthors, ", ", sep="")
              }
            }
          } else {
            for (j in 1:3) {
              prettyAuthors <- paste(prettyAuthors, nestedAuthors[[i]]$last_name[[j]], sep="")
              if (j == 3) {
                prettyAuthors <- paste(prettyAuthors, " et al.", sep="")
              } else {
                prettyAuthors <- paste(prettyAuthors, ", ", sep="")
              }
            }
          }
          nameList <- c(nameList, prettyAuthors)
        }
        lastNames <- rank
        lastNames <- cbind(lastNames, data.frame(nameList, stringsAsFactors = FALSE))
        colnames(lastNames) <- c("rank", "authors")
        # drop existing authors col
        countryArticles <- subset(countryArticles, select=-c(authors))
        # merge the newly created authors column
        countryArticles <- merge(countryArticles, lastNames)
      }
      
      # extract the inner 'identifiers' df (nested object in json) if it exists      
      if ("identifiers" %in% colnames(countryArticles)) {
        ids <- rank
        ids <- cbind(ids, countryArticles$identifiers)
        colnames(ids)[1] <- "rank"
        countryArticles <- merge(countryArticles, ids)
      }
      
      header <- c("CountryCode", "rank", "authors", "year", "title", "source", "volume", "issue", "pages", "doi", "pmid", "issn")
      # fill in missing cols to make joining work
      for (col in header) {
        if (!(col %in% colnames(countryArticles))) {
          countryArticles[,col] <- ""
        }
      }
      trimmedCountryArticles <- countryArticles[header]
      # all NA to empty string
      trimmedCountryArticles[is.na(trimmedCountryArticles)] <- ""
      # clean pages column of literal "n/a"
      trimmedCountryArticles$pages <- ifelse(grepl("n/a", trimmedCountryArticles$pages, fixed=TRUE), "", trimmedCountryArticles$pages)
      
      # add formatting to make reference strings(eg volume(issue):pages)
      trimmedCountryArticles$issue <- ifelse(nchar(trimmedCountryArticles$issue) > 0, paste("(", paste(trimmedCountryArticles$issue, ")", sep=""), sep = ""), "")
      trimmedCountryArticles$pages <- ifelse(nchar(trimmedCountryArticles$pages) > 0, paste(":", trimmedCountryArticles$pages, sep = ""), "")
      
      # construct a single identifier, preferring doi,issn,pmid 
      idList <- c()
      for (i in 1:length(trimmedCountryArticles$title)) {
        id <- ""
        if (!is.na(trimmedCountryArticles$doi[[i]]) && nchar(trimmedCountryArticles$doi[[i]]) > 0) {
          id <- paste("doi:", trimmedCountryArticles$doi[[i]], sep="")
        } else if (!is.na(trimmedCountryArticles$issn[[i]]) && nchar(trimmedCountryArticles$issn[[i]]) > 0) {
          id <- paste("issn:", trimmedCountryArticles$issn[[i]], sep="")
        } else if (!is.na(trimmedCountryArticles$pmid[[i]]) && nchar(trimmedCountryArticles$pmid[[i]]) > 0) {
          id <- paste("pmid:", trimmedCountryArticles$pmid[[i]], sep="")
        }
        idList <- c(idList, id)
      }
      ids <- rank
      ids <- cbind(ids, data.frame(idList))
      colnames(ids) <- c("rank", "identifier")
      # drop doi, pmid, issn cols
      trimmedCountryArticles <- subset(trimmedCountryArticles, select=-c(doi, pmid, issn))
      # merge the newly created ids column
      trimmedCountryArticles <- merge(trimmedCountryArticles, ids)
      
      recentArticles <- rbind(recentArticles, trimmedCountryArticles)
    }
  }
  
  # now have up to 5 rows per country and need to convert multiple rows to multiple columns instead
  # now transform into one row per country
  flatArticles <- NULL
  for (i in 1:5) {
    singleRank <- recentArticles[recentArticles$rank == i,]
    # rename columns
    header <- c(paste(paste("pub", i, sep=""), "_rank", sep=""),
                "CountryCode", 
                paste(paste("pub", i, sep=""), "_authors", sep=""),
                paste(paste("pub", i, sep=""), "_year", sep=""),
                paste(paste("pub", i, sep=""), "_title", sep=""),
                paste(paste("pub", i, sep=""), "_source", sep=""),
                paste(paste("pub", i, sep=""), "_volume", sep=""),
                paste(paste("pub", i, sep=""), "_issue", sep=""),
                paste(paste("pub", i, sep=""), "_pages", sep=""),
                paste(paste("pub", i, sep=""), "_identifier", sep="")
    )
    colnames(singleRank) <- header

    if (is.null(flatArticles)) {
      flatArticles <- singleRank
    } else {
      flatArticles <- merge(flatArticles, singleRank, by="CountryCode", all.x = TRUE)
    }
  } 
  # all NA to empty string
  flatArticles[is.na(flatArticles)] <- ""
  
  return(flatArticles)
}
