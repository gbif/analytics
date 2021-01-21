source("R/csv/utils.R")

extractAreaCSV(
  areaType = "country",
  sourceFile = "occ_country.csv",
  sourceSchema = c("snapshot", "country", "occurrenceCount"),
  targetFile = "occ.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "country",
  sourceFile = "occ_publisherCountry.csv",
  sourceSchema = c("snapshot", "publisherCountry", "occurrenceCount"),
  targetFile = "occ.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "occ_gbifRegion.csv",
  sourceSchema = c("snapshot", "gbifRegion", "occurrenceCount"),
  targetFile = "occ.csv",
  group = c("gbifRegion"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "occ_publisherGbifRegion.csv",
  sourceSchema = c("snapshot", "publisherGbifRegion", "occurrenceCount"),
  targetFile = "occ.csv",
  group = c("publisherGbifRegion"),
  groupLabel = c("publishedBy")
)

# This data is duplicated into the global folder for convenience.
prepareGlobalCSV(
  sourceFile = "occ_country.csv",
  sourceSchema = c("snapshot", "country", "occurrenceCount"),
  targetFile = "occ_country.csv"
)

# This data is duplicated into the global folder for convenience.
prepareGlobalCSV(
  sourceFile = "occ_publisherCountry.csv",
  sourceSchema = c("snapshot", "publisherCountry", "occurrenceCount"),
  targetFile = "occ_publisherCountry.csv"
)

# This data is duplicated into the global folder for convenience.
prepareGlobalCSV(
  sourceFile = "occ_gbifRegion.csv",
  sourceSchema = c("snapshot", "gbifRegion", "occurrenceCount"),
  targetFile = "occ_gbifRegion.csv"
)

# This data is duplicated into the global folder for convenience.
prepareGlobalCSV(
  sourceFile = "occ_publisherGbifRegion.csv",
  sourceSchema = c("snapshot", "publisherGbifRegion", "occurrenceCount"),
  targetFile = "occ_publisherGbifRegion.csv"
)

prepareGlobalCSV(
  sourceFile = "occ.csv",
  sourceSchema = c("snapshot", "occurrenceCount"),
  targetFile = "occ.csv"
)
