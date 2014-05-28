source("R/csv/Utils.R")

extractCountryCSV(
  sourceFile = "occ_country_yearCollected.csv", 
  sourceSchema = c("snapshot", "country", "year", "occurrenceCount"),
  targetFile = "occ_yearCollected.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractCountryCSV(
  sourceFile = "occ_publisherCountry_yearCollected.csv", 
  sourceSchema = c("snapshot", "publisherCountry", "year", "occurrenceCount"),
  targetFile = "occ_yearCollected.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "occ_yearCollected.csv", 
  sourceSchema = c("snapshot", "year", "occurrenceCount"),
  targetFile = "occ_yearCollected.csv"
)
