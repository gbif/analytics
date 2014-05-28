source("R/csv/Utils.R")

extractCountryCSV(
  sourceFile = "spe_country_repatriation.csv", 
  sourceSchema = c("snapshot", "country", "national", "international"),
  targetFile = "spe_repatriation.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractCountryCSV(
  sourceFile = "spe_publisherCountry_repatriation.csv", 
  sourceSchema = c("snapshot", "publisherCountry", "national", "international"),
  targetFile = "spe_repatriation.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "spe_repatriation.csv", 
  sourceSchema = c("snapshot", "national", "international"),
  targetFile = "spe_repatriation.csv"
)
