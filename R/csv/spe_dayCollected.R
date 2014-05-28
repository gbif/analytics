source("R/csv/Utils.R")

extractCountryCSV(
  sourceFile = "spe_country_dayCollected.csv", 
  sourceSchema = c("snapshot", "country", "day", "speciesCount"),
  targetFile = "spe_dayCollected.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractCountryCSV(
  sourceFile = "spe_publisherCountry_dayCollected.csv", 
  sourceSchema = c("snapshot", "publisherCountry", "day", "speciesCount"),
  targetFile = "spe_dayCollected.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "spe_dayCollected.csv", 
  sourceSchema = c("snapshot", "day", "speciesCount"),
  targetFile = "spe_dayCollected.csv"
)
