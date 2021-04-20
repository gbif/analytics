source("R/csv/utils.R")

# density 0.1 degree
extractAreaCSV(
  areaType = "country",
  sourceFile = "occ_density_country_point_one_deg.csv",
  sourceSchema = c("snapshot", "country", "latitude", "longitude", "count"),
  targetFile = "occ_density_point_one_deg.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "country",
  sourceFile = "occ_density_publisherCountry_point_one_deg.csv",
  sourceSchema = c("snapshot", "publisherCountry", "latitude", "longitude", "count"),
  targetFile = "occ_density_point_one_deg.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "occ_density_gbifRegion_point_one_deg.csv",
  sourceSchema = c("snapshot", "gbifRegion", "latitude", "longitude", "count"),
  targetFile = "occ_density_point_one_deg.csv",
  group = c("gbifRegion"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "occ_density_publisherGbifRegion_point_one_deg.csv",
  sourceSchema = c("snapshot", "publisherGbifRegion", "latitude", "longitude", "count"),
  targetFile = "occ_density_point_one_deg.csv",
  group = c("publisherGbifRegion"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "occ_density_point_one_deg.csv",
  sourceSchema = c("snapshot", "latitude", "longitude", "count"),
  targetFile = "occ_density_point_one_deg.csv"
)
