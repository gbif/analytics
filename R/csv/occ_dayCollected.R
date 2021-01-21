source("R/csv/utils.R")

extractAreaCSV(
  areaType = "country",
  sourceFile = "occ_country_dayCollected.csv",
  sourceSchema = c("snapshot", "country", "day", "occurrenceCount"),
  targetFile = "occ_dayCollected.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "country",
  sourceFile = "occ_publisherCountry_dayCollected.csv",
  sourceSchema = c("snapshot", "publisherCountry", "day", "occurrenceCount"),
  targetFile = "occ_dayCollected.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "occ_gbifRegion_dayCollected.csv",
  sourceSchema = c("snapshot", "gbifRegion", "day", "occurrenceCount"),
  targetFile = "occ_dayCollected.csv",
  group = c("gbifRegion"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "occ_publisherGbifRegion_dayCollected.csv",
  sourceSchema = c("snapshot", "publisherGbifRegion", "day", "occurrenceCount"),
  targetFile = "occ_dayCollected.csv",
  group = c("publisherGbifRegion"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "occ_dayCollected.csv",
  sourceSchema = c("snapshot", "day", "occurrenceCount"),
  targetFile = "occ_dayCollected.csv"
)
