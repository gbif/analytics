source("R/csv/Utils.R")

extractCountryCSV(
  sourceFile = "occ_country_kingdom_basisOfRecord.csv", 
  sourceSchema = c("snapshot", "country", "kingdom", "basisOfRecord", "occurrenceCount"),
  targetFile = "occ_kingdom_basisOfRecord.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractCountryCSV(
  sourceFile = "occ_publisherCountry_kingdom_basisOfRecord.csv", 
  sourceSchema = c("snapshot", "publisherCountry", "kingdom", "basisOfRecord", "occurrenceCount"),
  targetFile = "occ_kingdom_basisOfRecord.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "occ_kingdom_basisOfRecord.csv", 
  sourceSchema = c("snapshot", "kingdom", "basisOfRecord", "occurrenceCount"),
  targetFile = "occ_kingdom_basisOfRecord.csv"
)
