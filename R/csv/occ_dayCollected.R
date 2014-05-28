source("R/csv/Utils.R")

extractCountryCSV(
  sourceFile = "occ_country_dayCollected.csv", 
  sourceSchema = c("snapshot", "country", "day", "occurrenceCount"),
  targetFile = "occ_dayCollected.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractCountryCSV(
  sourceFile = "occ_publisherCountry_dayCollected.csv", 
  sourceSchema = c("snapshot", "publisherCountry", "day", "occurrenceCount"),
  targetFile = "occ_dayCollected.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "occ_dayCollected.csv", 
  sourceSchema = c("snapshot", "day", "occurrenceCount"),
  targetFile = "occ_dayCollected.csv"
)
