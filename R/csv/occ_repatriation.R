source("R/csv/utils.R")

extractCountryCSV(
  sourceFile = "occ_country_repatriation.csv", 
  sourceSchema = c("snapshot", "country", "national", "international"),
  targetFile = "occ_repatriation.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractCountryCSV(
  sourceFile = "occ_publisherCountry_repatriation.csv", 
  sourceSchema = c("snapshot", "publisherCountry", "national", "international"),
  targetFile = "occ_repatriation.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "occ_repatriation.csv", 
  sourceSchema = c("snapshot", "national", "international"),
  targetFile = "occ_repatriation.csv"
)
