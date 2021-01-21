source("R/csv/utils.R")

extractAreaCSV(
  areaType = "country",
  sourceFile = "occ_country_complete.csv",
  sourceSchema = c("snapshot", "country", "basisOfRecord", "rank", "geospatial", "temporal", "occurrenceCount"),
  targetFile = "occ_complete.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "country",
  sourceFile = "occ_publisherCountry_complete.csv",
  sourceSchema = c("snapshot", "publisherCountry", "basisOfRecord", "rank", "geospatial", "temporal", "occurrenceCount"),
  targetFile = "occ_complete.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "occ_gbifRegion_complete.csv",
  sourceSchema = c("snapshot", "gbifRegion", "basisOfRecord", "rank", "geospatial", "temporal", "occurrenceCount"),
  targetFile = "occ_complete.csv",
  group = c("gbifRegion"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "occ_publisherGbifRegion_complete.csv",
  sourceSchema = c("snapshot", "publisherGbifRegion", "basisOfRecord", "rank", "geospatial", "temporal", "occurrenceCount"),
  targetFile = "occ_complete.csv",
  group = c("publisherGbifRegion"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "occ_complete.csv",
  sourceSchema = c("snapshot", "basisOfRecord", "rank", "geospatial", "temporal", "occurrenceCount"),
  targetFile = "occ_complete.csv"
)
