source("R/csv/Utils.R")

extractCountryCSV(
  sourceFile = "spe_country_kingdom.csv", 
  sourceSchema = c("snapshot", "country", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractCountryCSV(
  sourceFile = "spe_publisherCountry_kingdom.csv", 
  sourceSchema = c("snapshot", "publisherCountry", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "spe_kingdom.csv", 
  sourceSchema = c("snapshot", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom.csv"
)

extractCountryCSV(
  sourceFile = "spe_country_kingdom_observation.csv", 
  sourceSchema = c("snapshot", "country", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom_observation.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractCountryCSV(
  sourceFile = "spe_publisherCountry_kingdom_observation.csv", 
  sourceSchema = c("snapshot", "publisherCountry", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom_observation.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "spe_kingdom_observation.csv", 
  sourceSchema = c("snapshot", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom_observation.csv"
)

extractCountryCSV(
  sourceFile = "spe_country_kingdom_specimen.csv", 
  sourceSchema = c("snapshot", "country", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom_specimen.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractCountryCSV(
  sourceFile = "spe_publisherCountry_kingdom_specimen.csv", 
  sourceSchema = c("snapshot", "publisherCountry", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom_specimen.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "spe_kingdom_specimen.csv", 
  sourceSchema = c("snapshot", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom_specimen.csv"
)