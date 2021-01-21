source("R/csv/utils.R")

extractAreaCSV(
  areaType = "country",
  sourceFile = "occ_country_kingdom_basisOfRecord.csv",
  sourceSchema = c("snapshot", "country", "kingdom", "basisOfRecord", "occurrenceCount"),
  targetFile = "occ_kingdom_basisOfRecord.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "country",
  sourceFile = "occ_publisherCountry_kingdom_basisOfRecord.csv",
  sourceSchema = c("snapshot", "publisherCountry", "kingdom", "basisOfRecord", "occurrenceCount"),
  targetFile = "occ_kingdom_basisOfRecord.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "occ_gbifRegion_kingdom_basisOfRecord.csv",
  sourceSchema = c("snapshot", "gbifRegion", "kingdom", "basisOfRecord", "occurrenceCount"),
  targetFile = "occ_kingdom_basisOfRecord.csv",
  group = c("gbifRegion"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "occ_publisherGbifRegion_kingdom_basisOfRecord.csv",
  sourceSchema = c("snapshot", "publisherGbifRegion", "kingdom", "basisOfRecord", "occurrenceCount"),
  targetFile = "occ_kingdom_basisOfRecord.csv",
  group = c("publisherGbifRegion"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "occ_kingdom_basisOfRecord.csv",
  sourceSchema = c("snapshot", "kingdom", "basisOfRecord", "occurrenceCount"),
  targetFile = "occ_kingdom_basisOfRecord.csv"
)
