source("R/csv/utils.R")

extractCountryCSV(
  sourceFile = "occ_country_basisOfRecord_complete.csv", 
  sourceSchema = c("snapshot", "country", "basisOfRecord", "complete", "total"),
  targetFile = "occ_basisOfRecord_complete.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractCountryCSV(
  sourceFile = "occ_publisherCountry_basisOfRecord_complete.csv", 
  sourceSchema = c("snapshot", "publisherCountry", "basisOfRecord", "complete", "total"),
  targetFile = "occ_basisOfRecord_complete.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "occ_basisOfRecord_complete.csv", 
  sourceSchema = c("snapshot", "basisOfRecord", "complete", "total"),
  targetFile = "occ_basisOfRecord_complete.csv"
)