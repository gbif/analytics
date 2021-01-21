source("R/csv/utils.R")

# 1.0 degree
extractAreaCSV(
  areaType = "country",
  sourceFile = "occ_country_cell_one_deg.csv",
  sourceSchema = c("snapshot", "country", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_one_deg.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "country",
  sourceFile = "occ_publisherCountry_cell_one_deg.csv",
  sourceSchema = c("snapshot", "publisherCountry", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_one_deg.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "occ_gbifRegion_cell_one_deg.csv",
  sourceSchema = c("snapshot", "gbifRegion", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_one_deg.csv",
  group = c("gbifRegion"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "occ_publisherGbifRegion_cell_one_deg.csv",
  sourceSchema = c("snapshot", "publisherGbifRegion", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_one_deg.csv",
  group = c("publisherGbifRegion"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "occ_cell_one_deg.csv",
  sourceSchema = c("snapshot", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_one_deg.csv"
)

# 0.1 degree
extractAreaCSV(
  areaType = "country",
  sourceFile = "occ_country_cell_point_one_deg.csv",
  sourceSchema = c("snapshot", "country", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_point_one_deg.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "country",
  sourceFile = "occ_publisherCountry_cell_point_one_deg.csv",
  sourceSchema = c("snapshot", "publisherCountry", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_point_one_deg.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "occ_gbifRegion_cell_point_one_deg.csv",
  sourceSchema = c("snapshot", "gbifRegion", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_point_one_deg.csv",
  group = c("gbifRegion"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "occ_publisherGbifRegion_cell_point_one_deg.csv",
  sourceSchema = c("snapshot", "publisherGbifRegion", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_point_one_deg.csv",
  group = c("publisherGbifRegion"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "occ_cell_point_one_deg.csv",
  sourceSchema = c("snapshot", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_point_one_deg.csv"
)

# 0.5 degree
extractAreaCSV(
  areaType = "country",
  sourceFile = "occ_country_cell_half_deg.csv",
  sourceSchema = c("snapshot", "country", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_half_deg.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "country",
  sourceFile = "occ_publisherCountry_cell_half_deg.csv",
  sourceSchema = c("snapshot", "publisherCountry", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_half_deg.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "occ_gbifRegion_cell_half_deg.csv",
  sourceSchema = c("snapshot", "gbifRegion", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_half_deg.csv",
  group = c("gbifRegion"),
  groupLabel = c("about")
)

extractAreaCSV(
  areaType = "gbifRegion",
  sourceFile = "occ_publisherGbifRegion_cell_half_deg.csv",
  sourceSchema = c("snapshot", "publisherGbifRegion", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_half_deg.csv",
  group = c("publisherGbifRegion"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "occ_cell_half_deg.csv",
  sourceSchema = c("snapshot", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_half_deg.csv"
)
