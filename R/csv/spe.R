source("R/csv/utils.R")

extractCountryCSV(
  sourceFile = "spe_country.csv",
  sourceSchema = c("snapshot", "country", "speciesCount"),
  targetFile = "spe.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractCountryCSV(
  sourceFile = "spe_publisherCountry.csv",
  sourceSchema = c("snapshot", "publisherCountry", "speciesCount"),
  targetFile = "spe.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

# This data is duplicated into the global folder for convenience.
prepareGlobalCSV(
  sourceFile = "spe_country.csv",
  sourceSchema = c("snapshot", "country", "speciesCount"),
  targetFile = "spe_country.csv"
)

# This data is duplicated into the global folder for convenience.
prepareGlobalCSV(
  sourceFile = "spe_publisherCountry.csv",
  sourceSchema = c("snapshot", "publisherCountry", "speciesCount"),
  targetFile = "spe_publisherCountry.csv"
)

prepareGlobalCSV(
  sourceFile = "spe.csv",
  sourceSchema = c("snapshot", "speciesCount"),
  targetFile = "spe.csv"
)
