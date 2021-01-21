source("R/csv/utils.R")

extractAreaCSV(
  areaType = "country",
  sourceFile = "spe_country.csv",
  sourceSchema = c("snapshot", "country", "speciesCount"),
  targetFile = "spe.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "country",
  sourceFile = "spe_publisherCountry.csv",
  sourceSchema = c("snapshot", "publisherCountry", "speciesCount"),
  targetFile = "spe.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "spe_gbifRegion.csv",
  sourceSchema = c("snapshot", "gbifRegion", "speciesCount"),
  targetFile = "spe.csv",
  group = c("gbifRegion"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "spe_publisherGbifRegion.csv",
  sourceSchema = c("snapshot", "publisherGbifRegion", "speciesCount"),
  targetFile = "spe.csv",
  group = c("publisherGbifRegion"),
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

# This data is duplicated into the global folder for convenience.
prepareGlobalCSV(
  sourceFile = "spe_gbifRegion.csv",
  sourceSchema = c("snapshot", "gbifRegion", "speciesCount"),
  targetFile = "spe_gbifRegion.csv"
)

# This data is duplicated into the global folder for convenience.
prepareGlobalCSV(
  sourceFile = "spe_publisherGbifRegion.csv",
  sourceSchema = c("snapshot", "publisherGbifRegion", "speciesCount"),
  targetFile = "spe_publisherGbifRegion.csv"
)

prepareGlobalCSV(
  sourceFile = "spe.csv",
  sourceSchema = c("snapshot", "speciesCount"),
  targetFile = "spe.csv"
)
