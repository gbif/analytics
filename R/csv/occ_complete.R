source("R/csv/Utils.R")

extractCountryCSV(
  sourceFile = "occ_country_complete.csv", 
  sourceSchema = c("snapshot", "country", "basisOfRecord", "rank", "geospatial", "temporal", "occurrenceCount"),
  targetFile = "occ_complete.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractCountryCSV(
  sourceFile = "occ_publisherCountry_complete.csv", 
  sourceSchema = c("snapshot", "publisherCountry", "basisOfRecord", "rank", "geospatial", "temporal", "occurrenceCount"),
  targetFile = "occ_complete.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "occ_complete.csv", 
  sourceSchema = c("snapshot", "basisOfRecord", "rank", "geospatial", "temporal", "occurrenceCount"),
  targetFile = "occ_complete.csv"
)