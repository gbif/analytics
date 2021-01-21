source("R/csv/utils.R")

extractAreaCSV(
  areaType = "country",
  sourceFile = "occ_country_yearCollected.csv",
  sourceSchema = c("snapshot", "country", "year", "occurrenceCount"),
  targetFile = "occ_yearCollected.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "country",
  sourceFile = "occ_publisherCountry_yearCollected.csv",
  sourceSchema = c("snapshot", "publisherCountry", "year", "occurrenceCount"),
  targetFile = "occ_yearCollected.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "occ_gbifRegion_yearCollected.csv",
  sourceSchema = c("snapshot", "gbifRegion", "year", "occurrenceCount"),
  targetFile = "occ_yearCollected.csv",
  group = c("gbifRegion"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "occ_publisherGbifRegion_yearCollected.csv",
  sourceSchema = c("snapshot", "publisherGbifRegion", "year", "occurrenceCount"),
  targetFile = "occ_yearCollected.csv",
  group = c("publisherGbifRegion"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "occ_yearCollected.csv",
  sourceSchema = c("snapshot", "year", "occurrenceCount"),
  targetFile = "occ_yearCollected.csv"
)
