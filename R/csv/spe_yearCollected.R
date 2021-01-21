source("R/csv/utils.R")

extractAreaCSV(
  areaType = "country",
  sourceFile = "spe_country_yearCollected.csv",
  sourceSchema = c("snapshot", "country", "year", "speciesCount"),
  targetFile = "spe_yearCollected.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "country",
  sourceFile = "spe_publisherCountry_yearCollected.csv",
  sourceSchema = c("snapshot", "publisherCountry", "year", "speciesCount"),
  targetFile = "spe_yearCollected.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "spe_gbifRegion_yearCollected.csv",
  sourceSchema = c("snapshot", "gbifRegion", "year", "speciesCount"),
  targetFile = "spe_yearCollected.csv",
  group = c("gbifRegion"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "spe_publisherGbifRegion_yearCollected.csv",
  sourceSchema = c("snapshot", "publisherGbifRegion", "year", "speciesCount"),
  targetFile = "spe_yearCollected.csv",
  group = c("publisherGbifRegion"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "spe_yearCollected.csv",
  sourceSchema = c("snapshot", "year", "speciesCount"),
  targetFile = "spe_yearCollected.csv"
)
