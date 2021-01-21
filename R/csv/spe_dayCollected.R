source("R/csv/utils.R")

extractAreaCSV(
  areaType = "country",
  sourceFile = "spe_country_dayCollected.csv",
  sourceSchema = c("snapshot", "country", "day", "speciesCount"),
  targetFile = "spe_dayCollected.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "country",
  sourceFile = "spe_publisherCountry_dayCollected.csv",
  sourceSchema = c("snapshot", "publisherCountry", "day", "speciesCount"),
  targetFile = "spe_dayCollected.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "spe_gbifRegion_dayCollected.csv",
  sourceSchema = c("snapshot", "gbifRegion", "day", "speciesCount"),
  targetFile = "spe_dayCollected.csv",
  group = c("gbifRegion"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "spe_publisherGbifRegion_dayCollected.csv",
  sourceSchema = c("snapshot", "publisherGbifRegion", "day", "speciesCount"),
  targetFile = "spe_dayCollected.csv",
  group = c("publisherGbifRegion"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "spe_dayCollected.csv",
  sourceSchema = c("snapshot", "day", "speciesCount"),
  targetFile = "spe_dayCollected.csv"
)
