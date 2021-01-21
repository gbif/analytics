source("R/csv/utils.R")

# kingdom
extractAreaCSV(
  areaType = "country",
  sourceFile = "spe_country_kingdom.csv",
  sourceSchema = c("snapshot", "country", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "country",
  sourceFile = "spe_publisherCountry_kingdom.csv",
  sourceSchema = c("snapshot", "publisherCountry", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "spe_gbifRegion_kingdom.csv",
  sourceSchema = c("snapshot", "gbifRegion", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom.csv",
  group = c("gbifRegion"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "spe_publisherGbifRegion_kingdom.csv",
  sourceSchema = c("snapshot", "publisherGbifRegion", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom.csv",
  group = c("publisherGbifRegion"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "spe_kingdom.csv",
  sourceSchema = c("snapshot", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom.csv"
)

# kingdom observation
extractAreaCSV(
  areaType = "country",
  sourceFile = "spe_country_kingdom_observation.csv",
  sourceSchema = c("snapshot", "country", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom_observation.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "country",
  sourceFile = "spe_publisherCountry_kingdom_observation.csv",
  sourceSchema = c("snapshot", "publisherCountry", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom_observation.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "spe_gbifRegion_kingdom_observation.csv",
  sourceSchema = c("snapshot", "gbifRegion", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom_observation.csv",
  group = c("gbifRegion"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "spe_publisherGbifRegion_kingdom_observation.csv",
  sourceSchema = c("snapshot", "publisherGbifRegion", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom_observation.csv",
  group = c("publisherGbifRegion"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "spe_kingdom_observation.csv",
  sourceSchema = c("snapshot", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom_observation.csv"
)

# kingdom specimen
extractAreaCSV(
  areaType = "country",
  sourceFile = "spe_country_kingdom_specimen.csv",
  sourceSchema = c("snapshot", "country", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom_specimen.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "country",
  sourceFile = "spe_publisherCountry_kingdom_specimen.csv",
  sourceSchema = c("snapshot", "publisherCountry", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom_specimen.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "spe_gbifRegion_kingdom_specimen.csv",
  sourceSchema = c("snapshot", "gbifRegion", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom_specimen.csv",
  group = c("gbifRegion"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "spe_publisherGbifRegion_kingdom_specimen.csv",
  sourceSchema = c("snapshot", "publisherGbifRegion", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom_specimen.csv",
  group = c("publisherGbifRegion"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "spe_kingdom_specimen.csv",
  sourceSchema = c("snapshot", "kingdom", "speciesCount"),
  targetFile = "spe_kingdom_specimen.csv"
)
