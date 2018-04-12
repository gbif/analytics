file.copy(from="R/html-json/assets", to="report", recursive=TRUE)


# install.packages("jsonlite", repos="http://cran.r-project.org")
library(jsonlite)
source("R/html-json/utils.R")

countries <- country_lists()
about_countries <- countries[[1]]
publishing_countries <- countries[[2]]

# write the json files for about and pub
about_json <- toJSON(about_countries, pretty=TRUE)
cat(about_json, file="report/countries_about.json")
published_json <- toJSON(publishing_countries, pretty=TRUE)
cat(published_json, file="report/countries_published.json")