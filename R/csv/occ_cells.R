source("R/csv/utils.R")

extractCountryCSV(
  sourceFile = "occ_country_cell_one_deg.csv", 
  sourceSchema = c("snapshot", "country", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_one_deg.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractCountryCSV(
  sourceFile = "occ_publisherCountry_cell_one_deg.csv", 
  sourceSchema = c("snapshot", "publisherCountry", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_one_deg.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "occ_cell_one_deg.csv", 
  sourceSchema = c("snapshot", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_one_deg.csv"
)


extractCountryCSV(
  sourceFile = "occ_country_cell_point_one_deg.csv", 
  sourceSchema = c("snapshot", "country", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_point_one_deg.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractCountryCSV(
  sourceFile = "occ_publisherCountry_cell_point_one_deg.csv", 
  sourceSchema = c("snapshot", "publisherCountry", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_point_one_deg.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "occ_cell_point_one_deg.csv", 
  sourceSchema = c("snapshot", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_point_one_deg.csv"
)


extractCountryCSV(
  sourceFile = "occ_country_cell_half_deg.csv", 
  sourceSchema = c("snapshot", "country", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_half_deg.csv",
  group = c("country"),
  groupLabel = c("about")
)

extractCountryCSV(
  sourceFile = "occ_publisherCountry_cell_half_deg.csv", 
  sourceSchema = c("snapshot", "publisherCountry", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_half_deg.csv",
  group = c("publisherCountry"),
  groupLabel = c("publishedBy")
)

prepareGlobalCSV(
  sourceFile = "occ_cell_half_deg.csv", 
  sourceSchema = c("snapshot", "one_cell","under_twenty_cells","under_hundred_cells","under_thousand_cells","over_thousand_cells"),
  targetFile = "occ_cell_half_deg.csv"
)




