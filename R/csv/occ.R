source("R/csv/utils.R")

extractCountryCSV(
  sourceFile = "occ_country.csv",
  sourceSchema = c("snapshot", "country", "occurrenceCount"),
  targetFile = "occ.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractCountryCSV(
  sourceFile = "occ_publisherCountry.csv",
  sourceSchema = c("snapshot", "publisherCountry", "occurrenceCount"),
  targetFile = "occ.csv",
  group = c("publisherCountry"),
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

prepareGlobalCSV(
  sourceFile = "occ.csv",
  sourceSchema = c("snapshot", "occurrenceCount"),
  targetFile = "occ.csv"
)
