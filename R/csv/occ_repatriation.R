source("R/csv/utils.R")

extractAreaCSV(
  areaType = "country",
  sourceFile = "occ_country_repatriation.csv",
  sourceSchema = c("snapshot", "country", "national", "international"),
  targetFile = "occ_repatriation.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "country",
  sourceFile = "occ_publisherCountry_repatriation.csv",
  sourceSchema = c("snapshot", "publisherCountry", "national", "international"),
  targetFile = "occ_repatriation.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "occ_gbifRegion_repatriation.csv",
  sourceSchema = c("snapshot", "gbifRegion", "national", "international"),
  targetFile = "occ_repatriation.csv",
  group = c("gbifRegion"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "occ_publisherGbifRegion_repatriation.csv",
  sourceSchema = c("snapshot", "publisherGbifRegion", "national", "international"),
  targetFile = "occ_repatriation.csv",
  group = c("publisherGbifRegion"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "occ_repatriation.csv",
  sourceSchema = c("snapshot", "national", "international"),
  targetFile = "occ_repatriation.csv"
)
