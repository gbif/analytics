source("R/csv/utils.R")

extractCountryCSV(
  sourceFile = "spe_country_yearCollected.csv", 
  sourceSchema = c("snapshot", "country", "year", "speciesCount"),
  targetFile = "spe_yearCollected.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractCountryCSV(
  sourceFile = "spe_publisherCountry_yearCollected.csv", 
  sourceSchema = c("snapshot", "publisherCountry", "year", "speciesCount"),
  targetFile = "spe_yearCollected.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "spe_yearCollected.csv", 
  sourceSchema = c("snapshot", "year", "speciesCount"),
  targetFile = "spe_yearCollected.csv"
)
